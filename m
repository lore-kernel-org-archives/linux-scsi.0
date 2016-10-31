From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 00/60] block: support multipage bvec
Date: Tue, 1 Nov 2016 06:52:08 +0800
Message-ID: <CACVXFVN7Cnf8CqsnQwJEeOJTQr=qmHWLrieO++0XXcK3=mWQCw@mail.gmail.com>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com> <20161031152519.GA25791@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20161031152519.GA25791@infradead.org>
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Bart Van Assche <bart.vanassche@sandisk.com>, "open list:GFS2 FILE SYSTEM" <cluster-devel@redhat.com>, Coly Li <colyli@suse.de>, Dan Williams <dan.j.williams@intel.com>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, "open list:DRBD DRIVER" <drbd-dev@lists.linbit.com>, Eric Wheeler <git@linux.ewheeler.net>, Guoqing Jiang <gqjiang@suse.com>, Hannes Reinecke <hare@suse.com>, Hannes Reinecke <hare@suse.de>, Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>, Johannes Berg <johannes.berg@intel.com>, Johannes Thumshirn <jthumshirn@suse.de>, Kei
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 31, 2016 at 11:25 PM, Christoph Hellwig <hch@infradead.org> wrote:
> Hi Ming,
>
> can you send a first patch just doing the obvious cleanups like
> converting to bio_add_page and replacing direct poking into the
> bio with the proper accessors?  That should help reducing the

OK, that is just the 1st part of the patchset.

> actual series to a sane size, and it should also help to cut
> down the Cc list.
>



Thanks,
Ming Lei

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
