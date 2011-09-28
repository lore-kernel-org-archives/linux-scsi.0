From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] block: Free queue resources at blk_release_queue()
Date: Tue, 27 Sep 2011 17:55:24 -0700
Message-ID: <CA+55aFznvejXWe68BpjsJqCWnDizbHWBOzKLY_H+YqhRiK42sQ@mail.gmail.com>
References: <201109221318.p8MDIXPP020015@pentland.suse.de> <20110928004722.GA27421@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110928004722.GA27421@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 27, 2011 at 5:47 PM, Jens Axboe <axboe@kernel.dk> wrote:
>
> Do we have acks from the people who saw this oops, that this really does
> fix it for them? I ask since this fix is vastly cleaner than the other
> patch floating around, so I'd much rather pull this one in.

I don't think I can't test it, since it seems to be some hard-to-hit
race condition. It certainly doesn't seem to happen all the time -
today was the first time I've seen it on one of my computers.

But if you forward the actual patch to me (the one I see on lkml seems
to be broken and doesn't compile cleanly because it's assiging a
structure to a pointer), I'll try it out anyway.

                     Linus
