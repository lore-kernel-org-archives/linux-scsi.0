From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/60] block: support multipage bvec
Date: Mon, 31 Oct 2016 08:25:19 -0700
Message-ID: <20161031152519.GA25791@infradead.org>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
Sender: owner-linux-mm@kvack.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Al Viro <viro@ZenIV.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Bart Van Assche <bart.vanassche@sandisk.com>, "open list:GFS2 FILE SYSTEM" <cluster-devel@redhat.com>, Coly Li <colyli@suse.de>, Dan Williams <dan.j.williams@intel.com>, "open list:DEVICE-MAPPER  (LVM)" <dm-devel@redhat.com>, "open list:DRBD DRIVER" <drbd-dev@lists.linbit.com>, Eric Wheeler <git@linux.ewheeler.net>, Guoqing Jiang <gqjiang@suse.com>, Hannes Reinecke <hare@suse.com>, Hannes Reinecke <hare@suse.de>, Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>, Johannes Berg <johannes.berg@intel.com>, Johannes Thumshirn <jthumshirn@suse.de>, Keith Busch <keith.busch@in>
List-Id: linux-scsi@vger.kernel.org

Hi Ming,

can you send a first patch just doing the obvious cleanups like
converting to bio_add_page and replacing direct poking into the
bio with the proper accessors?  That should help reducing the
actual series to a sane size, and it should also help to cut
down the Cc list.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
