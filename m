From: Matthew Jacob <mjacob@feral.com>
Subject: [ getting OT ] Re: Warning - running *really* short on DMA buffers
 while  doingfiletransfers
Date: Sun, 29 Sep 2002 09:49:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0209290942060.25666-100000@beppo>
References: <200209291545.g8TFj2v09855@localhost.localdomain>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <200209291545.g8TFj2v09855@localhost.localdomain>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> > I've already written one OpenSource SCSI mid-layer, given
> > presentations on how to fix the Linux mid-layer, and try to discuss
> > these issues with Linux developers.  I just don't have the energy to
> > go implement a real solution for Linux only to have it thrown away.
> > Life's too short.  8-)
> 
> What can I say? I've always found the life of an open source developer to be a 
> pretty thankless, filled with bug reports, irate complaints about feature 
> breakage and tossed code.  The worst I think is "This code looks fine now why 
> don't you <insert feature requiring a complete re-write of proposed code>".
> 
> I can ceratinly sympathise with anyone not wanting to work in this 
> environment.  I just don't see it changing soon.

Justin, and all of us, are quite content to work in an Open Source
environment I believe. It is the true inheritor of the original Unix
philosophies.

But it's difficult to commit to an effort that one often feels is a
waste of time from the git go. This is one of the bootstrapping problems
of the Linux environment: pretty much everyone expects you to produce a
working prototype of a problem solution *before* people will accept it-
how else can they evaluate it, hmm?

But major amounts of work would have to be expended before you would do
something like present 'CAM in linux' for review. That makes for a
natural tendency to try and assess *beforehand* whether there's even a
point in trying. I think that the subtext of Justin's comment, to put
words in his mouth which can later deny if he likes, is that there's a
sense that some of the solutions he'd propose/do would never be
accepted, so why spend an effort sure to be wasted?
