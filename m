From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: megaraid_sas: fix a missing-check bug
Date: Tue, 16 Oct 2018 17:56:33 -0400
Message-ID: <yq1pnw9r1wu.fsf@oracle.com>
References: <1538850861-26882-1-git-send-email-wang6495@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1538850861-26882-1-git-send-email-wang6495@umn.edu> (Wenwen
        Wang's message of "Sat, 6 Oct 2018 13:34:21 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:MEGARAID SCSI/SAS DRIVERS" <megaraidlinux.pdl@broadcom.com>, "open list:MEGARAID SCSI/SAS DRIVERS" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Wenwen,

> This patch enforces a check on the two kernel variables 'local_sense_off'
> and 'user_sense_off' to make sure they are the same after the copy. In case
> they are not, an error code EINVAL will be returned.

Applied to 4.20/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
