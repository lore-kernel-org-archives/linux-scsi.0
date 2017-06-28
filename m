From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 1/6] qla2xxx: Add FC-NVMe port discovery and PRLI
 handling
Date: Wed, 28 Jun 2017 14:15:45 -0700
Message-ID: <1498684545.2769.17.camel@HansenPartnership.com>
References: <20170621204846.21663-1-himanshu.madhani@cavium.com>
         <20170621204846.21663-2-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52616 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751545AbdF1VPt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 17:15:49 -0400
In-Reply-To: <20170621204846.21663-2-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Himanshu" <himanshu.madhani@cavium.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, darren.trapp@cavium.com, giridhar.malavali@cavium.com, linux-nvme@lists.infradead.org

On Wed, 2017-06-21 at 13:48 -0700, Madhani, Himanshu wrote:
> From: Duane Grigsby <duane.grigsby@cavium.com>
> 
> Added logic to change the login process into an optional PRIL
> step for FC-NVMe ports as a separate operation, such that we can
> change type to 0x28 (NVMe).
> 
> Currently, the driver performs the PLOGI/PRLI together as one
> operation, but if the discovered port is an NVMe port then we
> first issue the PLOGI and then we issue the PRLI. Also, the
> fabric discovery logic was changed to mark each discovered FC
> NVMe port, so that we can register them with the FC-NVMe transport
> later.
> 
> Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
> Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
> Signed-off-by: Anil Gurumurthy <anil.gurumurhty@cavium.com>

I just got a whole load of bounces from this: you've misspelled Anil's
email address (h and t transposed).  It looks like a generic cut and
paste, so could you fix it for next time?

Thanks,

James
