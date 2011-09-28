From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] block: Free queue resources at blk_release_queue()
Date: Tue, 27 Sep 2011 18:59:11 -0700
Message-ID: <CA+55aFyL76hD7o_839G7tKa0y6dFRcK-kC+g_h_coEp=Qk23pw@mail.gmail.com>
References: <201109221318.p8MDIXPP020015@pentland.suse.de> <20110928004722.GA27421@kernel.dk>
 <CA+55aFznvejXWe68BpjsJqCWnDizbHWBOzKLY_H+YqhRiK42sQ@mail.gmail.com> <4E82751C.9050908@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E82751C.9050908@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 27, 2011 at 6:15 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> But if you forward the actual patch to me (the one I see on lkml seems
>> to be broken and doesn't compile cleanly because it's assiging a
>> structure to a pointer), I'll try it out anyway.
>
> Thanks, that would be great. It's inlined below.

Well, I did several USB eject events, and nothing bad happened.

But as mentioned, I don't think that means much. Have you tried this
with slub debugging and poisoning? It might be worth some extra
testing that way.

                   Linus
