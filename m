From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Megaraid: Use of outb_p
Date: Tue, 22 Jan 2008 14:37:35 -0700
Message-ID: <20080122213735.GP27250@parisc-linux.org>
References: <20080118204113.GF20490@parisc-linux.org> <9738BCBE884FDB42801FAD8A7769C26501E60213@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:59407 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYAVVhg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jan 2008 16:37:36 -0500
Content-Disposition: inline
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26501E60213@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org, DL-MegaRAID Linux <megaraidlinux@lsi.com>

On Tue, Jan 22, 2008 at 02:30:12PM -0700, Yang, Bo wrote:
> Alan/Matthew,
> 
> I found inb_p/outb_p are defined as inb/outb in kernel src.  So it
> should not have problems to change inb_p/outb_p to inb/outb.

That's not true for x86-32.  Please, can you look up the documentation
for this chip and find out what sort of delay it needs?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
