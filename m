From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Megaraid: Use of outb_p
Date: Wed, 23 Jan 2008 10:53:37 +0000
Message-ID: <20080123105337.74d460cd@lxorguk.ukuu.org.uk>
References: <20080118204113.GF20490@parisc-linux.org>
	<9738BCBE884FDB42801FAD8A7769C26501E60213@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36338 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752159AbYAWKzz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jan 2008 05:55:55 -0500
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26501E60213@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, DL-MegaRAID Linux <megaraidlinux@lsi.com>

On Tue, 22 Jan 2008 14:30:12 -0700
"Yang, Bo" <Bo.Yang@lsi.com> wrote:

> Alan/Matthew,
> 
> I found inb_p/outb_p are defined as inb/outb in kernel src.  So it
> should not have problems to change inb_p/outb_p to inb/outb.

Only on some platforms. On the x86 platforms the inb_p()/outb_p() includes
a 2uS delay while inb/outb do not.

Alan
