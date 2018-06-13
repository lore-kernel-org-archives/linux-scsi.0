From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ipr: fix build on 32-bit architectures
Date: Wed, 13 Jun 2018 13:14:36 -0400
Message-ID: <yq18t7itxqb.fsf@oracle.com>
References: <20180608144617.2900894-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180608144617.2900894-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 8 Jun 2018 16:46:00 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kees Cook <keescook@chromium.org>, Hannes Reinecke <hare@suse.com>, Souptick Joarder <jrdr.linux@gmail.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Sinan Kaya <okaya@codeaurora.org>, Bart Van Assche <bart.vanassche@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> the conclusion was that drivers should generally assume that the
> barrier implied by writel() is sufficient for ordering DMA, so this
> reverts his change and instead removes the extraneous wmb() before it,
> which is no longer needed on any architecture now.

Applied to 4.18/scsi-fixes and squashed with Sinan's patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
