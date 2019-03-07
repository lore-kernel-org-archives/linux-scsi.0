From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/4] scsi: lpfc: fix unused variable warning
Date: Wed, 06 Mar 2019 19:15:24 -0500
Message-ID: <yq1h8cfwndv.fsf@oracle.com>
References: <20190304193917.702601-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190304193917.702601-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 4 Mar 2019 20:39:08 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> The newly introduced 'cpu' variable is only used inside of an optional
> block, so we get a warning without CONFIG_SCSI_LPFC_DEBUG_FS:

Applied to 5.1/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
