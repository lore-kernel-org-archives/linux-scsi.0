From: Jonathan <jonathan.625266@earthlink.net>
Subject: Re: uas - kernel panic on drive connection
Date: Fri, 11 Jul 2014 20:40:34 -0400
Message-ID: <20140711204034.745d85a4@earthlink.net>
References: <20140704104028.2014aaf4@earthlink.net>
	<53BCEA03.30304@redhat.com>
	<20140709193139.32049945@earthlink.net>
	<53BFB01C.6020900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:42203 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752648AbaGLAkf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2014 20:40:35 -0400
In-Reply-To: <53BFB01C.6020900@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>

Hans,

Sure enough, the enclosure worked flawlessly with uas on a machine with an Intel xhci controller (2012 MacBook Air running Linux with kernel 3.15.3). I  look forward to learning your results with the Etron controller.

Best,

Jonathan

On Fri, 11 Jul 2014 11:36:28 +0200
Hans de Goede <hdegoede@redhat.com> wrote:

> Etron, that is the first time I've heard of them. So that is the 5th manufacturer
> which is making xhci controllers now (the others are nec, intel, via and designware).
> 
> I've managed to find a pci-e add-on card using the same Etron chipset as you have,
> and I've ordered one, so that I can try and reproduce this problem. It will be
> aprox. 3 weeks before I get it though.
> 
> In the mean time, can you try the usb disk enclosure on a machine with a nec or
> intel xhci controller ? So that we can confirm that this is indeed a problem
> specific to the Etron controller?
> 
> Regards,
> 
> Hans
