From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 42/41 v2] dm: convey that all flushes are processed as
 empty
Date: Wed, 08 Sep 2010 18:09:43 +0200
Message-ID: <4C87B547.5080700@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org> <1283509796-1510-24-git-send-email-tj@kernel.org> <4C84CD18.6060906@redhat.com> <20100907211724.GA22525@redhat.com> <20100907221543.GB22525@redhat.com> <20100907234918.GA23921@redhat.com> <20100908000001.GA21552@lst.de> <20100908020429.GA24635@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100908020429.GA24635@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, jack@suse.cz, mst@redhat.com, linux-ide@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, k-ueda@ct.jp.nec.com, vst@vlnb.net, linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, linux-raid@vger.kernel.org, mpatocka@redhat.com, swhiteho@redhat.com, chris.mason@oracle.com, tytso@mit.edu, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, rwheeler@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 09/08/2010 04:04 AM, Mike Snitzer wrote:
> Rename __clone_and_map_flush to __clone_and_map_empty_flush for added
> clarity.
> 
> Simplify logic associated with REQ_FLUSH conditionals.
> 
> Introduce a BUG_ON() and add a few more helpful comments to the code
> so that it is clear that all flushes are empty.
> 
> Cleanup __split_and_process_bio() so that an empty flush isn't processed
> by a 'sector_count' focused while loop.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm.c |   34 +++++++++++++++-------------------
>  1 files changed, 15 insertions(+), 19 deletions(-)
> 
> Tejun, please feel free to fold this patch into (or insert after)
> 0025-dm-relax-ordering-of-bio-based-flush-implementation.patch

I added it after 26 and updated flush-fua branch accordingly.

Thank you.

-- 
tejun
