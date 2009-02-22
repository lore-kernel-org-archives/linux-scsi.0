From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH (resend)]: SCSI: fix /proc memory leak in the SCSI core
Date: Sun, 22 Feb 2009 14:34:09 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0902221431170.30449-100000@netrider.rowland.org>
References: <1235324436.4531.54.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:3587 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752141AbZBVTeM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Feb 2009 14:34:12 -0500
In-Reply-To: <1235324436.4531.54.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 22 Feb 2009, James Bottomley wrote:

> OK, but resending a patch you expressed reservations about putting in
> without testing doesn't really help me.  I need a way to get comfortable
> with its safety.
> 
> So, what about this alternative fix instead: if the removal were moved
> to scsi_host_put(), that would address all the problems and have the
> advantage that everyone will test it ...

I thought of doing it that way too.  It has the disadvantage of
exposing part of the proc interface to userspace before the host is
registered.  Now, since all we're adding is the host's directory, maybe 
this doesn't matter.  But it didn't seem like a good idea.

Alan Stern

