From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: 2.6.31-rc9 kernel BUG and mvsas
Date: Thu, 10 Dec 2009 14:04:25 -0700
Message-ID: <200912101404.26094.tfjellstrom@shaw.ca>
References: <200909090414.41274.tfjellstrom@shaw.ca> <alpine.DEB.1.10.0912051116400.23464@uplift.swm.pp.se> <alpine.DEB.1.10.0912102022460.23464@uplift.swm.pp.se>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:8734 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759434AbZLJVE3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2009 16:04:29 -0500
In-Reply-To: <alpine.DEB.1.10.0912102022460.23464@uplift.swm.pp.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-scsi <linux-scsi@vger.kernel.org>, Linux IDE mailing list <linux-ide@vger.kernel.org>

On Thu December 10 2009, Mikael Abrahamsson wrote:
> On Sat, 5 Dec 2009, Mikael Abrahamsson wrote:
> > When removing this extra option, it compiles with vanilla 2.6.32 just
> > fine. I crashes the same way as the ubuntu kernel when hot-plugging a
> > disk as well (this time I did it without gdm/x running and it oopses,
> > but unfortunately the highest part of the oops scrolled off). It's 100%
> > reproducible anyway, so basically the controller is a no-go in 2.6.31.6
> > and 2.6.32 both vanilla and ubuntu versions, both without and including
> > the nov09 mvsas patch (at least the original version of the patch as
> > posted). Different failure scenarios though... With the stock kernel
> > the controller seems to get stuck in writing and nothing more happens
> > but at least the machine doesn't crash and burn like it does with the
> > mvsas-patch.
> 
> Would it make sense for me to log this problem in bugzilla? There seems
>  to be a similar issue with equal hw:
> 
> <http://bugzilla.kernel.org/show_bug.cgi?id=14534>
> 
> did these fixes ever go upstream? Are they scheduled to go into the
> stable rebuilds of 2.6.32 ? The patches mentioned in there, are these the
> ones I already tried that didn't solve my problem?
> 

I'm really hoping Andy Yan or someone else on the project can get some time 
to polish up the last patch set posted to linux-scsi. There were a few 
comments regarding them, but no one has responded to them yet.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
