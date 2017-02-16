From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch] scsi: megaraid_sas: array overflow in megasas_dump_frame()
Date: Wed, 15 Feb 2017 21:38:09 -0500
Message-ID: <yq1lgt6c12m.fsf@oracle.com>
References: <20170214163855.GA1687@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170214163855.GA1687@mwanda> (Dan Carpenter's message of "Tue,
        14 Feb 2017 19:38:55 +0300")
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> The "sz" variable is in terms of bytes, but we're treating the
Dan> buffer as an array of __le32 so we have to divide by 4.

Dan> Fixes: def0eab3af86 ("scsi: megaraid_sas: enhance debug logs in OCR
Dan> context") Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
