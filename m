From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 07:00:22 -0700
Message-ID: <20071015070022.4a0c5957@laptopd505.fenrus.org>
References: <200710112011.22000.rob@landley.net>
	<200710141845.44750.rob@landley.net>
	<20071015060015.GB32268@kroah.com>
	<200710150336.15774.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49490 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948AbXJOOBL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 10:01:11 -0400
In-Reply-To: <200710150336.15774.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Mon, 15 Oct 2007 03:36:15 -0500
Rob Landley <rob@landley.net> wrote:

> The point I was trying to make is that it seems to me like it would
> be possible to keep the namespace separate here, and thus reduce the
> enumeration problems to the point where common cases (like my laptop)
> aren't impacted by them during early boot.  I don't think anybody
> (outside the embedded space) is actually upset that /dev/hda now goes
> through the scsi layer:  they're upset Ubuntu 7.04 no longer calls
> it /dev/hda.

that's a choice Ubuntu made in their udev scripts... if you don't like
it, complain to them.
I'm surprised you would even need to care about what device name things
are though.... with mount-by-label (deployed for a bunch of years now
in most distros), and various helpful links like /dev/cdrom ....

anyway.. if you don't like your distros udev configuration, lkml is the
wrong forum.
