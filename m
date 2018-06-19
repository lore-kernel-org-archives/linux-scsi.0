From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: scsi_debug: Fix memory leak on module unload
Date: Mon, 18 Jun 2018 22:17:29 -0400
Message-ID: <yq1k1qvikp2.fsf@oracle.com>
References: <20180618160803.11674-1-lhenriques@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618160803.11674-1-lhenriques@suse.com> (Luis Henriques's
        message of "Mon, 18 Jun 2018 17:08:03 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Luis Henriques <lhenriques@suse.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Luis,

> Since commit 80c49563e250 ("scsi: scsi_debug: implement IMMED bit")
> there are long delays in F_SYNC_DELAY and F_SSU_DELAY.  This can cause
> a memory leak in schedule_resp(), which can be invoked while unloading
> the scsi_debug module: free_all_queued() had already freed all sd_dp
> and schedule_resp will alloc a new one, which will never get freed.
> Here's the kmemleak report while running xfstests generic/350:

Applied to 4.18/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
