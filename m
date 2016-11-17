From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mvsas: fix command_active typo
Date: Wed, 16 Nov 2016 20:49:37 -0500
Message-ID: <yq1lgwian9q.fsf@sermon.lab.mkp.net>
References: <20161116150855.3083872-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161116150855.3083872-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Wed, 16 Nov 2016 16:08:34 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Xiangliang Yu <yuxiangl@marvell.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> gcc-7 notices that the condition in mvs_94xx_command_active looks
Arnd> suspicious:

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
