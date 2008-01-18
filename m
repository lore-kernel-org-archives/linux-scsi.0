From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Megaraid: Use of outb_p
Date: Fri, 18 Jan 2008 20:38:08 +0000
Message-ID: <20080118203808.13a38130@lxorguk.ukuu.org.uk>
References: <9738BCBE884FDB42801FAD8A7769C26501E5FD9C@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53954 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756881AbYARUju (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jan 2008 15:39:50 -0500
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26501E5FD9C@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, DL-MegaRAID Linux <megaraidlinux@lsi.com>

On Fri, 18 Jan 2008 13:32:12 -0700
"Yang, Bo" <Bo.Yang@lsi.com> wrote:

> Alan, 
> 
> The in/outb_p in MegaRAID scsi driver is used for our old io mapped
> megaraid controller.  There are still some customers are using those old
> controller.  Please keep them.

Do they need the I/O delays. If they need a delay they should use outb
and a udelay() of the correct length. If they do not need a delay they
should use outb()

Which is the correct change to make ?

Alan
