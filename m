From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: clean up generated file scsi_devinfo_tbl.c
Date: Mon, 14 May 2018 22:48:38 -0400
Message-ID: <yq17eo5my61.fsf@oracle.com>
References: <6e64c815-43dd-3945-6c58-66b1e0533403@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6e64c815-43dd-3945-6c58-66b1e0533403@infradead.org> (Randy
        Dunlap's message of "Sun, 13 May 2018 17:10:52 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, LKML <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org


Randy,

> "make clean" should remove the generated file "scsi_devinfo_tbl.c", so
> list it in the clean-files variable so that the file gets cleaned up.

Applied to 4.17/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
