From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6 patch] SCSI t128.c: remove an unused function
Date: Mon, 15 Nov 2004 19:49:32 +0000
Message-ID: <1100548155.27324.4.camel__20621.7047096745$1100554277$gmane$org@localhost.localdomain>
References: <20041115023859.GE2249@stusta.de>
	 <1100529621.27202.9.camel@localhost.localdomain>
	 <20041115170322.GB19860@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from clock-tower.bc.nu ([81.2.110.250]:43235 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S261697AbUKOUyq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 15:54:46 -0500
In-Reply-To: <20041115170322.GB19860@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Llu, 2004-11-15 at 17:03, Adrian Bunk wrote:
> On Mon, Nov 15, 2004 at 02:40:39PM +0000, Alan Cox wrote:
> > On Llu, 2004-11-15 at 02:38, Adrian Bunk wrote:
> > > The patch below removes the unused function t128_setup.
> > > 
> > > Please review whether it's correct.
> > 
> > Its wrong. The fix is to make the setup function get called, IFF you can
> > find anyone with a t128 any more
> 
> Ah, it seems your t128 fix which did this in 2.4.17-pre7 is (like your 
> dtc cleanup in the same patch) among the fixes not yet forward-ported 
> from 2.4 to 2.6 ...

Yep. Those probably want propogating so they don't get lost. Not that
5380's work in 2.6 with all the scsi changes as far as I can tell

