From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: fix oops/BUG in lpfc_sli_ringtxcmpl_put()
Date: Fri, 25 Nov 2016 10:00:16 -0500
Message-ID: <yq1poljtxj3.fsf@sermon.lab.mkp.net>
References: <1479904399-19496-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1479904399-19496-1-git-send-email-mauricfo@linux.vnet.ibm.com>
        (Mauricio Faria de Oliveira's message of "Wed, 23 Nov 2016 10:33:19
        -0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: james.smart@broadcom.com, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Mauricio" == Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com> writes:

Mauricio> The BUG_ON() recently introduced in lpfc_sli_ringtxcmpl_put()
Mauricio> is hit in the lpfc_els_abort() > lpfc_sli_issue_abort_iotag()
Mauricio> > lpfc_sli_abort_iotag_issue() function path [similar names],
Mauricio> due to 'piocb->vport == NULL':

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
