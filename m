From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] Re: AMD 53c974 SCSI driver in 2.6
Date: Sun, 2 Nov 2003 20:22:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311021933100.4615-100000@poirot.grange>
References: <20031031114616.A16435@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20031031114616.A16435@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, garloff@suse.de, gl@dsa-ac.de
List-Id: linux-scsi@vger.kernel.org

> > > Any reason you fix this driver?  The tmcsim one for the same hardware
> > > looks like much better structured (though a bit obsufacted :))?

Ok, started looking at the tmscsim. A couple of questions:

1) After the "next" element has disappeared from the struct scsi_cmnd,
what is the "correct" / preferred way to queue scsi commands in drivers?
I saw aic7xxx (new) casting a part of struct scsi_pointer SCp in
scsi_cmnd, starting from Status to a list_head (or an anology thereof),
which doesn't seem very nice. Anyway, I didn't find any "standard" way for
doing this. Should host_scribble be used?

2) Actually, which scsi driver (or, better, several drivers) can be
considered well-written and can be taken as examples? I tried looking at
aic7xxx, as it is a pretty new one, but I am not sure if it is really a
good example to follow and it is pretty big too.

Thanks
Guennadi

P.S. Should this thread be taken to linux-scsi or is it better to continue
it on lkml?
---
Guennadi Liakhovetski
