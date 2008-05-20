From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: lockdep whine in 2.6.26-rc2-mm1
Date: Mon, 19 May 2008 19:51:43 -0600
Message-ID: <20080520015142.GJ2638@parisc-linux.org>
References: <20080514000933.56adc131.akpm@linux-foundation.org> <20080514155639.GB28594@kroah.com> <20080514162442.GO9324@parisc-linux.org> <a8e1da0805142247k2456234evb5ea2be59da135cb@mail.gmail.com> <20080515090101.GA2915@darkstar.te-china.tietoenator.com> <20080515115203.GH9921@parisc-linux.org> <a8e1da0805170314v4253d01agc0d6f77438e27989@mail.gmail.com> <a8e1da0805182220y23412047g4969e3906a4c5aca@mail.gmail.com> <20080519102343.GB2638@parisc-linux.org> <a8e1da0805191827s6222ec65k8521359b188e6345@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37958 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbYETBv7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 21:51:59 -0400
Content-Disposition: inline
In-Reply-To: <a8e1da0805191827s6222ec65k8521359b188e6345@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>

On Tue, May 20, 2008 at 09:27:59AM +0800, Dave Young wrote:
> > The question isn't whether there is or isn't this kind of use right now.
> > The question is whether there might be this kind of use in the future,
> > and if there is, whether we'd like lockdep to warn us.
> 
> In the future, IMHO, the class_interface should go away just as
> class_device. If that happened this problem would going away as well.

Go away ... and be replaced by something else, right?  I mean, it's not
like we don't have a need to bind two kinds of driver to the same
device.  So we're going to continue to have the situation where you can
register a new kind of driver and want to create new devices, so we'll
still have a nesting of some kind.

> Your idea is good. But as I said above, for current situation there's
> no potential problems except class_interface usage, and the
> class_interface will go away
>  in the future.
> 
> So IMO It's not necessary to do this for all classes.

Assuming your analysis is correct, of course.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
