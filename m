From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/6] mac_esp, zorro_esp, esp_scsi: Various improvements
Date: Wed, 17 Oct 2018 21:40:02 -0400
Message-ID: <yq1h8hkkp71.fsf@oracle.com>
References: <cover.1539497520.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1539497520.git.fthain@telegraphics.com.au> (Finn Thain's
        message of "Sun, 14 Oct 2018 17:12:00 +1100")
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Finn,

> This series has fixes and cleanup for mac_esp, zorro_esp and the core
> esp_scsi driver.
>
> These improvements include elimination of duplicated code temporarily
> introduced for zorro_esp.

Had to hand-apply patch #5. Otherwise OK.

Applied to 4.20/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
