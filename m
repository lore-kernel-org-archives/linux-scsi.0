From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1 of 3] block: Globalize bio_set and bio_vec_slab
Date: Mon, 16 Jun 2008 21:21:07 +0200
Message-ID: <20080616192107.GW20851@kernel.dk>
References: <patchbomb.1213589417@sermon.lab.mkp.net> <24902abbf2b6fdb830f1.1213589418@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758023AbYFPTVp@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <24902abbf2b6fdb830f1.1213589418@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 16 2008, Martin K. Petersen wrote:
> Move struct bio_set and biovec_slab definitions to bio.h so they can
> be used outside of bio.c.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

I think I already acked this patch many months ago, obviously no
problems with this.

-- 
Jens Axboe
