From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Wed, 12 Feb 2003 17:15:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E4AC769.5000707@splentec.com>
References: <20030211081351.GA1368@beaverton.ibm.com> <3E492992.90502@splentec.com> <20030211172256.GC3164@beaverton.ibm.com> <3E494977.1070706@splentec.com> <3E495862.3050709@splentec.com> <20030211212048.GC1114@beaverton.ibm.com> <3E49698D.3030402@splentec.com> <20030211224119.A23149@infradead.org> <3E4AAA3F.8040002@splentec.com> <20030212204634.A17425@infradead.org> <20030212212340.GA7488@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

Mike Anderson wrote:
> 
> I like the idea, but for 2.5 cleaning the ~95 queuecommand functions
> seems large.

[On queuecommand() prototype.]

As I said, this would be quite easier than the host_lock.

I can do this, and would involve less work than getting rid
of the lun, target, channel from scsi_command...

It doesn't ``seem large'' *to me*.

Getting rid of the host_lock in LLDD would be a pickle though.

> I also agree about it being a 2.7 item, but I like it as a guide of
> where we should consider heading.

One can check out SAM-2/3 for the general infrastructure.

For the nitty-gritty of things like queuing, etc. I think I've
ambiguously spilled them here and there in my emails.

As to a working prototype, I have one such, but's its not GPL.

Anyway, we have plenty of ideas, all we need is the pistol pop.

BTW, the USB and FC ppl should like the newer TMF entries, and
userspace as well -- it should be able to invoke a cold target
rescan without problems.  Oh, a ``host'' should become a ``portal''
and the notion of channel/bus should disappear.  A ``target'' can
appear on more than one ``portal'', etc...

-- 
Luben


