From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Mark i2o config broken on 64-bit platforms.
Date: Wed, 9 Jul 2008 15:46:49 +0100
Message-ID: <20080709154649.57f66bb9@the-village.bc.nu>
References: <20080709113547.19235.15424.stgit@warthog.procyon.org.uk>
	<20080709044743.0dd15a3f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41107 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752195AbYGIPVV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2008 11:21:21 -0400
In-Reply-To: <20080709044743.0dd15a3f.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, alan@redhat.com, Markus.Lidel@shadowconnect.com, vvs@sw.ru, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> Sigh.  I've been staring at that warning for so long.
> 
> Is it actually known to be broken on 64-bit, or does it happen to work?

64bit kernel 32bit user space should be fine, aside of any DMA allocation
bugs. Actually 'fixing' it would mean adding a new 64bit clean ioctl but
given you only need the config tool very occassionally and I2O is almost
extinct but not quite dead yet nobody has bothered too much.

Alan
