From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2.6.13 14/14] sas-class: SCSI Host glue
Date: Mon, 12 Sep 2005 10:08:05 -0600
Message-ID: <20050912160805.GC32395@parisc-linux.org>
References: <1126308949.4799.54.camel@mulgrave> <20050910041218.29183.qmail@web51612.mail.yahoo.com> <20050911093847.GA5429@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751038AbVILQIN@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050911093847.GA5429@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>, James Bottomley <James.Bottomley@SteelEye.com>, Luben Tuikov <luben_tuikov@adaptec.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 11, 2005 at 10:38:47AM +0100, Christoph Hellwig wrote:
> On Fri, Sep 09, 2005 at 09:12:18PM -0700, Luben Tuikov wrote:
> > I long for the days of the previous maintainer.  Had it not been
> > for him and Andi, we may have never had scsi commands from a slab,
> > scsi_done queue, done_q softirq processing, scsi timer hook, etc.
> > Of course back then Splentec wasn't your payrol company, but there
> > was some common sense present in linux-scsi.
> 
> Could you please stop this bullshit spreading now, thanks?

I meant to reply to Luben's original, but I deleted it in disgust.
As the person who converted SCSI from the old bottom-half completion
processing first to a tasklet and then to a softirq, I'd like to refute
at least part of this allegation.  I didn't do it in order to improve
SCSI particularly, satisfy Splentec (who are they?), or prove a point.

I did it because I wanted to remove the old bottom-half mechanism and
SCSI was one of the remaining users.  That required me to learn a bit
about the SCSI stack and I got sucked in.  BTW, I believe at that time,
James had alreeady taken over maintenance.  I'm not actually sure who
the previous maintainer was -- was it Eric Biederman?

A colleague asked me to summarise the current dispute.  I said that
Luben's point was that nobody else understood SCSI.  Everybody else's
point was that Luben doesn't understand Linux kernel development.  Luben,
I think you need to shut up, accept advice, stop trying to do everything
in your own driver, and stop trying to have private conversations.
Just discuss things on linux-scsi dispassionately.  There's no hidden
agenda to get you or your company.  But you are pissing people off,
and very soon there *will* be because of your behaviour.
