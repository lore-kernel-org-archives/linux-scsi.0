From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: Suppress a kernel complaint in qla_init_base_qpair()
Date: Mon, 06 Nov 2017 23:08:14 -0500
Message-ID: <yq1375q3f4h.fsf@oracle.com>
References: <20171106195905.5139-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171106195905.5139-1-bart.vanassche@wdc.com> (Bart Van Assche's
        message of "Mon, 6 Nov 2017 11:59:05 -0800")
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Quinn Tran <quinn.tran@cavium.com>, Himanshu Madhani <himanshu.madhani@cavium.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Bart,

> Avoid that the following is reported while loading the qla2xxx
> kernel module:

Applied to 4.15/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
