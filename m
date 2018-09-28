From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/10] NCR5380: Various improvements
Date: Fri, 28 Sep 2018 02:29:13 -0400
Message-ID: <yq1h8iab0ee.fsf@oracle.com>
References: <cover.1538011031.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1538011031.git.fthain@telegraphics.com.au> (Finn Thain's
        message of "Thu, 27 Sep 2018 11:17:11 +1000")
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, Ondrey Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Finn,

> This series addresses issues which became apparent when Michael
> Schmitz tried to use an AztecMonster II SATA/SCSI adapter with a 5380
> host.
>
> That target seems to have some bugs which thoroughly exercise driver
> error paths and EH.
>
> The patch by Hannes Reinecke was cherry-picked from his 'eh-reset.v5'
> branch.

Applied to 4.20/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
