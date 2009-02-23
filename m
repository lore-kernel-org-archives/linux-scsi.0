From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH (resend)]: SCSI: fix /proc memory leak in the SCSI core
Date: Sun, 22 Feb 2009 19:56:57 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0902221954370.2011-100000@netrider.rowland.org>
References: <1235331963.4531.61.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:4333 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750784AbZBWA47 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Feb 2009 19:56:59 -0500
In-Reply-To: <1235331963.4531.61.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 22 Feb 2009, James Bottomley wrote:

> On Sun, 2009-02-22 at 14:34 -0500, Alan Stern wrote:
> > On Sun, 22 Feb 2009, James Bottomley wrote:
> > 
> > > OK, but resending a patch you expressed reservations about putting in
> > > without testing doesn't really help me.  I need a way to get comfortable
> > > with its safety.
> > > 
> > > So, what about this alternative fix instead: if the removal were moved
> > > to scsi_host_put(), that would address all the problems and have the
> > > advantage that everyone will test it ...
> > 
> > I thought of doing it that way too.  It has the disadvantage of
> > exposing part of the proc interface to userspace before the host is
> > registered.  Now, since all we're adding is the host's directory, maybe 
> > this doesn't matter.  But it didn't seem like a good idea.
> 
> It's current behaviour (and has been so for all of git history) with no
> reported bugs.
> 
> All it's doing is creating a proc dir ... it's not exposing any
> interfaces within, so from a theoretical standpoint it's perfectly OK.
> The necessity for finding a legacy system to test was precisely because
> you moved it.

Okay.  Then either patch is fine with me.

Alan Stern

