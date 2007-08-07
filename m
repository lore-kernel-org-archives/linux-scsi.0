From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Tue, 7 Aug 2007 15:55:21 +0100
Message-ID: <20070807155521.0dc9f068@the-village.bc.nu>
References: <1186248703.3439.20.camel@localhost.localdomain>
	<alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>
	<1186458941.6637.44.camel@localhost.localdomain>
	<20070807001429.f8cb3b22.akpm@linux-foundation.org>
	<1186496712.3414.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52780 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753240AbXHGOsZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2007 10:48:25 -0400
In-Reply-To: <1186496712.3414.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

> I fully agree, and firmly believe that the current stabilisation works
> incredibly well for shaking out bugs.  My problem is that it doesn't
> work for stabilising features.  Either we have to get far more people
> doing feature integration testing before the merge window, or we have to
> accept feature updates after the merge window (for existing features
> that are having stability issues).

The other alternative is that if Linus won't take updates you ask him to
revert bsg so that you don't get a half baked merge as a result of this.
I'm not sure that is a good path to follow either however.

