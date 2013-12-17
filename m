From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/7] lpfc 8.3.44: Fixed IO hang when in msi mode.
Date: Tue, 17 Dec 2013 12:30:44 -0800
Message-ID: <1387312244.2213.76.camel@dabdike.int.hansenpartnership.com>
References: <1386006499.11046.9.camel@myfc17>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38827 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484Ab3LQUaq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Dec 2013 15:30:46 -0500
In-Reply-To: <1386006499.11046.9.camel@myfc17>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org

On Mon, 2013-12-02 at 12:48 -0500, James Smart wrote:
> Fixed IO hang when in msi mode.
> 
> 
> Signed-off-by: James Smart <james.smart@emulex.com>

There seems to be a lot of tab vs space checkpatch warnings in this
series:

ERROR: code indent should use tabs where possible
#24: FILE: drivers/scsi/lpfc/lpfc_scsi.c:4792:
+                                 cmnd->device ? cmnd->device->lun :
0xffff,$

WARNING: please, no spaces at the start of a line
#24: FILE: drivers/scsi/lpfc/lpfc_scsi.c:4792:
+                                 cmnd->device ? cmnd->device->lun :
0xffff,$

ERROR: code indent should use tabs where possible
#25: FILE: drivers/scsi/lpfc/lpfc_scsi.c:4793:
+                                 vport->fc_myDID, ndlp->nlp_DID,$

WARNING: please, no spaces at the start of a line
#25: FILE: drivers/scsi/lpfc/lpfc_scsi.c:4793:
+                                 vport->fc_myDID, ndlp->nlp_DID,$

ERROR: code indent should use tabs where possible
#26: FILE: drivers/scsi/lpfc/lpfc_scsi.c:4794:
+                                 phba->sli_rev == LPFC_SLI_REV4 ?$

WARNING: please, no spaces at the start of a line
#26: FILE: drivers/scsi/lpfc/lpfc_scsi.c:4794:
+                                 phba->sli_rev == LPFC_SLI_REV4 ?$

ERROR: code indent should use tabs where possible
#27: FILE: drivers/scsi/lpfc/lpfc_scsi.c:4795:
+                                 lpfc_cmd->cur_iocbq.sli4_xritag :
0xffff,$

WARNING: please, no spaces at the start of a line
#27: FILE: drivers/scsi/lpfc/lpfc_scsi.c:4795:
+                                 lpfc_cmd->cur_iocbq.sli4_xritag :
0xffff,$

ERROR: code indent should use tabs where possible
#28: FILE: drivers/scsi/lpfc/lpfc_scsi.c:4796:
+                                 lpfc_cmd->cur_iocbq.iocb.ulpContext,$

WARNING: please, no spaces at the start of a line
#28: FILE: drivers/scsi/lpfc/lpfc_scsi.c:4796:
+                                 lpfc_cmd->cur_iocbq.iocb.ulpContext,$

ERROR: code indent should use tabs where possible
#29: FILE: drivers/scsi/lpfc/lpfc_scsi.c:4797:
+                                 lpfc_cmd->cur_iocbq.iocb.ulpIoTag,$

WARNING: please, no spaces at the start of a line
#29: FILE: drivers/scsi/lpfc/lpfc_scsi.c:4797:
+                                 lpfc_cmd->cur_iocbq.iocb.ulpIoTag,$

ERROR: code indent should use tabs where possible
#30: FILE: drivers/scsi/lpfc/lpfc_scsi.c:4798:
+                                 lpfc_cmd->cur_iocbq.iocb.ulpTimeout,$

WARNING: please, no spaces at the start of a line
#30: FILE: drivers/scsi/lpfc/lpfc_scsi.c:4798:
+                                 lpfc_cmd->cur_iocbq.iocb.ulpTimeout,$

ERROR: code indent should use tabs where possible
#31: FILE: drivers/scsi/lpfc/lpfc_scsi.c:4799:
+                                 (uint32_t)$

WARNING: please, no spaces at the start of a line
#31: FILE: drivers/scsi/lpfc/lpfc_scsi.c:4799:
+                                 (uint32_t)$

ERROR: code indent should use tabs where possible
#32: FILE: drivers/scsi/lpfc/lpfc_scsi.c:4800:
+                                  (cmnd->request->timeout / 1000));$

WARNING: please, no spaces at the start of a line
#32: FILE: drivers/scsi/lpfc/lpfc_scsi.c:4800:
+                                  (cmnd->request->timeout / 1000));$

total: 9 errors, 9 warnings, 33 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

I don't think it's your mailer otherwise the patch wouldn't have
applied.  Could you fix and resend the series?

Thanks,

James


