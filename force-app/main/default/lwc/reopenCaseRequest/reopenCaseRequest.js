import { LightningElement, wire, api } from "lwc";
import { getFieldValue, getRecord, updateRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import NAME_FIELD from "@salesforce/schema/Case_Request__c.Name";
import SLA_DEADLINE_FIELD from "@salesforce/schema/Case_Request__c.SLA_Deadline__c";
import STATUS_FIELD from "@salesforce/schema/Case_Request__c.Status__c";

export default class ReopenCaseRequest extends LightningElement {
  caseRequest;
  deadline;
  timer;
  setTimeInterval;

  @api recordId;

  @wire(getRecord, {
    recordId: "$recordId",
    fields: [NAME_FIELD, SLA_DEADLINE_FIELD, STATUS_FIELD]
  })
  caseRequestData({ data, error }) {
    if (data) {
      this.caseRequest = data;
      this.timeUntilSLAViolation();
    }
    if (error) {
      console.error(error);
    }
  }

  get slaDeadline() {
    return getFieldValue(this.caseRequest, SLA_DEADLINE_FIELD);
  }

  get status() {
    return getFieldValue(this.caseRequest, STATUS_FIELD);
  }

  get isClosed() {
    return this.status === "Closed";
  }

  get isNotClosed() {
    return !this.isClosed;
  }

  handleClick() {
    const fields = {};
    fields["Id"] = this.recordId;
    fields[STATUS_FIELD.fieldApiName] = "In Progress";

    const recordInput = { fields };

    updateRecord(recordInput)
      .then(() => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Sucesso",
            message: "O caso foi reaberto",
            variant: "success"
          })
        );
      })
      .catch((error) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Erro",
            message: error.body.message,
            variant: "error"
          })
        );
      });
  }

  timeUntilSLAViolation() {
    this.deadline = this.slaDeadline;
    clearInterval(this.setTimeInterval);

    // eslint-disable-next-line @lwc/lwc/no-async-operation
    this.setTimeInterval = setInterval(() => {
      let day = new Date(this.deadline);
      let ddate = day.getTime();
      let currentDateTime = new Date().getTime();
      let timeDifference = ddate - currentDateTime;

      if (timeDifference < 0) {
        clearInterval(this.setTimeInterval);
        this.timer = "Prazo expirado!";
      } else {
        let days = Math.floor(timeDifference / (1000 * 60 * 60 * 24));
        let hours = Math.floor(
          (timeDifference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)
        );
        let minutes = Math.floor(
          (timeDifference % (1000 * 60 * 60)) / (1000 * 60)
        );
        let seconds = Math.floor((timeDifference % (1000 * 60)) / 1000);

        this.timer =
          days +
          " dias " +
          hours +
          " hrs " +
          minutes +
          " mins " +
          seconds +
          " segs";
      }
    }, 1000);
  }
}
