From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla1280: set 64bit coherent mask
Date: Fri, 11 Jan 2019 22:31:18 -0500
Message-ID: <yq1r2div9fd.fsf@oracle.com>
References: <20190109140902.21638-1-tbogendoerfer@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190109140902.21638-1-tbogendoerfer@suse.de> (Thomas
        Bogendoerfer's message of "Wed, 9 Jan 2019 15:09:02 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc: Michael Reed <mdr@sgi.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Thomas,

> Reason is that SGI IP27 always generates 64bit DMA addresses and has
> no fallback mode for 32bit DMA addresses implemented. QLA1280
> supports 64bit addressing for all DMA accesses so setting coherent mask
> to 64bit fixes the issue.

Applied to 5.0/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
