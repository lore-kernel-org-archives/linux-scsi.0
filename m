From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: Megaraid: Use of outb_p
Date: Tue, 22 Jan 2008 14:42:37 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C26501E60225@NAMAIL1.ad.lsil.com>
References: <20080122213735.GP27250@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:33519 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbYAVVmv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jan 2008 16:42:51 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20080122213735.GP27250@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org, DL-MegaRAID Linux <megaraidlinux@lsi.com>


Alan/Matthew,

I will double check and give you back soon.

Regards.

Bo Yang 

-----Original Message-----
From: Matthew Wilcox [mailto:matthew@wil.cx] 
Sent: Tuesday, January 22, 2008 4:38 PM
To: Yang, Bo
Cc: Alan Cox; linux-scsi@vger.kernel.org; DL-MegaRAID Linux
Subject: Re: Megaraid: Use of outb_p

On Tue, Jan 22, 2008 at 02:30:12PM -0700, Yang, Bo wrote:
> Alan/Matthew,
> 
> I found inb_p/outb_p are defined as inb/outb in kernel src.  So it 
> should not have problems to change inb_p/outb_p to inb/outb.

That's not true for x86-32.  Please, can you look up the documentation
for this chip and find out what sort of delay it needs?

--
Intel are signing my paycheques ... these opinions are still mine "Bill,
look, we understand that you're interested in selling us this operating
system, but compare it to ours.  We can't possibly take such a
retrograde step."
