From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] mpt3sas: Recognize and act on iopriority info
Date: Wed, 14 Dec 2016 15:41:26 -0500
Message-ID: <yq1bmweb5vt.fsf@sermon.lab.mkp.net>
References: <1481589100-3342-1-git-send-email-adam.manzanares@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481589100-3342-1-git-send-email-adam.manzanares@hgst.com> (Adam
        Manzanares's message of "Mon, 12 Dec 2016 16:31:40 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Adam Manzanares <adam.manzanares@hgst.com>
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Adam Manzanares <adam.manzanares@wdc.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Adam" == Adam Manzanares <adam.manzanares@hgst.com> writes:

Adam> This patch adds support for request iopriority handling in the
Adam> mpt3sas layer. This works only when a ATA device is behind the
Adam> SATL. The ATA device also has to indicate that it supports command
Adam> priorities in the identify information that is pulled from the
Adam> SATL.

Applied to 4.10/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
