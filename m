From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] scsi: trivial header search path fixups
Date: Tue, 29 Jan 2019 01:24:01 -0500
Message-ID: <yq15zu8dlry.fsf@oracle.com>
References: <1548400144-22513-1-git-send-email-yamada.masahiro@socionext.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548400144-22513-1-git-send-email-yamada.masahiro@socionext.com>
        (Masahiro Yamada's message of "Fri, 25 Jan 2019 16:09:02 +0900")
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Don Brace <don.brace@microsemi.com>, esc.storagedev@microsemi.com, Hannes Reinecke <hare@suse.com>, linux-kernel@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@microsemi.com>
List-Id: linux-scsi@vger.kernel.org


Masahiro,

> My main motivation is to get rid of crappy header search path manipulation
> from Kbuild core.
>
> Before that, I want to do as many treewide cleanups as possible.

Applied to 5.1/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
