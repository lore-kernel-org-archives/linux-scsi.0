From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/4] scsi: pmcraid: fix lock imbalance in pmcraid_reset_reload()
Date: Mon, 24 Apr 2017 18:02:42 -0400
Message-ID: <yq1fugxihvh.fsf@oracle.com>
References: <20170420175549.3435196-1-arnd@arndb.de>
        <20170420175549.3435196-2-arnd@arndb.de>
        <20170423083635.GB30869@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170423083635.GB30869@infradead.org> (Christoph Hellwig's
        message of "Sun, 23 Apr 2017 01:36:35 -0700")
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>, Quentin Lambert <lambert.quentin@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Christoph,

> sparse found a bug that has always been present since the driver was
> merged:
>
> drivers/scsi/pmcraid.c:2353:12: warning: context imbalance in 'pmcraid_reset_reload' - different lock contexts for basic block
>
> Fix this by using a common unlock goto label, and also reduce the
> indentation level in the function.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
