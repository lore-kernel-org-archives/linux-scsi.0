From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: be2iscsi: Use kasprintf
Date: Fri, 03 Nov 2017 12:25:11 -0400
Message-ID: <yq17ev772jc.fsf@oracle.com>
References: <1507736174-13089-1-git-send-email-himanshujha199640@gmail.com>
        <20171103151613.GA2601@himanshu-Vostro-3559>
        <yq1o9oj75bi.fsf@oracle.com>
        <20171103161052.GA11274@himanshu-Vostro-3559>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171103161052.GA11274@himanshu-Vostro-3559> (Himanshu Jha's
        message of "Fri, 3 Nov 2017 21:40:52 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com
List-Id: linux-scsi@vger.kernel.org


Himanshu,

>> It is not. It needs a review/ack from the driver maintainers.
>
> What about Kyle Fortin's review ?

Kyle's review is fine. But when a driver is actively maintained, like
be2iscsi is, I always give ack/nack rights to the relevant maintainers.
In this case that's Jitendra.

-- 
Martin K. Petersen	Oracle Linux Engineering
