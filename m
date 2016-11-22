From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH 00/12] block: cleanup direct access to bvec table
Date: Tue, 22 Nov 2016 08:53:00 -0700
Message-ID: <167c2511-349f-a8e6-17d1-f7ce438b2f14@fb.com>
References: <1478865957-25252-1-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1478865957-25252-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Adrian Hunter <adrian.hunter@intel.com>, Coly Li <colyli@suse.de>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, "open list:DRBD DRIVER" <drbd-dev@lists.linbit.com>, Eric Wheeler <git@linux.ewheeler.net>, Guoqing Jiang <gqjiang@suse.com>, Hannes Reinecke <hare@suse.com>, Jiri Kosina <jkosina@suse.cz>, Johannes Thumshirn <jthumshirn@suse.de>, Keith Busch <keith.busch@intel.com>, Kent Overstreet <kent.overstreet@gmail.com>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>, "open list:NVM EXPRESS TARGET DRIVER" <linux-nvme@lists.infradead.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/11/2016 05:05 AM, Ming Lei wrote:
> Hi,
>
> This patchset cleans up direct access to bvec table.
>
> The 1st patch passes bvec table to bio_init(), so that
> direct access to bvec table in bio initialization is avoided.
>
> For other patches, most of them uses bio_add_page()
> to replace hardcode style of adding page to bvec,
> and others avoids to access bio->bi_vcnt.
>
> The most special one is to use bvec iterator helpers
> to implement .get_page/.next_page for dm-io.c
>
> One big motivation is to prepare for supporting multipage
> bvec, but this patchset is one good cleanup too even not
> for that purpose.

I've added the series, except 6-8, the dm parts. I updated some of the
descriptions/subjects to read a little better.

-- 
Jens Axboe

