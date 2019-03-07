From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/4] scsi: lpfc: fix 32-bit format string warning
Date: Wed, 06 Mar 2019 19:15:37 -0500
Message-ID: <yq1d0n3wndi.fsf@oracle.com>
References: <20190304193917.702601-1-arnd@arndb.de>
        <20190304193917.702601-2-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190304193917.702601-2-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 4 Mar 2019 20:39:09 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Colin Ian King <colin.king@canonical.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> On 32-bit architectures, we see a warning when %ld is used to
> print a size_t:

Applied to 5.1/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
