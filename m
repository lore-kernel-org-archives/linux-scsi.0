From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: Megaraid: Use of outb_p
Date: Wed, 30 Jan 2008 15:14:46 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C26501EA0050@NAMAIL1.ad.lsil.com>
References: <20080123105337.74d460cd@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:34535 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411AbYA3WPH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jan 2008 17:15:07 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20080123105337.74d460cd@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, DL-MegaRAID Linux <megaraidlinux@lsi.com>

Alan,

As you pointed out, there are only 2uS difference on x86 platforms for
the changes.  Also the inb_p/outb_p are used for the very old megaraid
scsi controllers.  The src changes should be ok for us.

Regards.

Bo Yang 

-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] 
Sent: Wednesday, January 23, 2008 5:54 AM
To: Yang, Bo
Cc: Matthew Wilcox; linux-scsi@vger.kernel.org; DL-MegaRAID Linux
Subject: Re: Megaraid: Use of outb_p

On Tue, 22 Jan 2008 14:30:12 -0700
"Yang, Bo" <Bo.Yang@lsi.com> wrote:

> Alan/Matthew,
> 
> I found inb_p/outb_p are defined as inb/outb in kernel src.  So it 
> should not have problems to change inb_p/outb_p to inb/outb.

Only on some platforms. On the x86 platforms the inb_p()/outb_p()
includes a 2uS delay while inb/outb do not.

Alan
