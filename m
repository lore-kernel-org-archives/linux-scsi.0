From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi/megaraid_sas: fix a compilation warning
Date: Wed, 07 Aug 2019 21:30:06 -0400
Message-ID: <yq1r25we95t.fsf@oracle.com>
References: <1564151143-22889-1-git-send-email-cai@lca.pw>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1564151143-22889-1-git-send-email-cai@lca.pw> (Qian Cai's
        message of "Fri, 26 Jul 2019 10:25:43 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Qian Cai <cai@lca.pw>
Cc: martin.petersen@oracle.com, jejb@linux.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Qian,

> The commit de516379e85f ("scsi: megaraid_sas: changes to function
> prototypes") introduced a comilation warning due to it changed the
> function prototype of read_fw_status_reg() to take an instance pointer
> instead, but forgot to remove an unused variable.

Applied to 5.4/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
