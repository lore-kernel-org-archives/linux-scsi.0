From: Oliver Xymoron <oxymoron@waste.org>
Subject: Re: [PATCH] sd.c fixes applied incorectly to 2.4.19-preXX
Date: Tue, 16 Apr 2002 11:18:01 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0204161055070.3933-100000@waste.org>
References: <200204161456.g3GEuo302374@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200204161456.g3GEuo302374@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi@vger.kernel.org, Alan Cox <alan@redhat.com>

On Tue, 16 Apr 2002, James Bottomley wrote:

> gibbs@scsiguy.com said:
> > In my opinion, the only way to really fix the Linux SCSI layer is to
> > rip it out and start over using prior art from systems with functional
> > I/O subsystems as a guide to building something enterprise worthy.  As
> > soon as the community becomes serious about such an endevor, so will
> > I. 8-)
>
> Not perhaps for ripping it up and starting again.  However, there are
> more ways than one to skin a cat.  If you can outline a set of
> principles, it may be possible to move current development towards them.
> How about just the five worst things about the current subsystem and how
> we could address them?

>From my recent inspection:

1) sense handling
2) timeouts and error recovery
3) initialization and lun probing
4) scalability
5) readability

In short, all the corner cases are handled with layer on layer of bandaids
and while it works fine for most people with desktop systems, it's really
showing its age when you start messing with storage networking and
hotplugging.

As it stands, SCSI is one of the few subsystems that hasn't gotten a major
overhaul in recent years. As 2.5 is shaping up to be a revamp of the whole
VM/paging/FS/IO/IDE chain and the BIO stuff seems to have settled down,
now is a really good time to start thinking about plugging a cleaner SCSI
layer in.

-- 
 "Love the dolphins," she advised him. "Write by W.A.S.T.E.."

