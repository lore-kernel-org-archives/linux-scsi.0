From: "Smart, James" <James.Smart@Emulex.Com>
Subject: RE: [PATCH] dead code and missing statics in lpfc
Date: Thu, 10 Jun 2004 09:24:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28034F9490@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:5036 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S261236AbUFJNYP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jun 2004 09:24:15 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

You are missing the whole point of this email!

> Well, bad luck.  With that stance from Emulex we'd better 
> stop any work on
> getting it included if you're not interested in it beeing a 
> 1st class citicen.

As the end of the email stated - this is NOT the stance that Emulex wants,
nor is promoting. Believe me - the last thing we want is two variants of the
driver. The efforts that we have taken over the last several months should
give evidence to what our goal is and how much skin we're willing to put in.
Sure, we've had work to do. Until the recently, our goals were not the same.
I also admit, I didn't like the code in place. But then, I wasn't there in
the building, but I am trying to rebuild it, and nothing happens overnight.

> What you're missing is that the Linux kernel can very well 
> live without a
> Emulex driver, but it will hurt Emulex if it's not properly 
> supported by
> Linux.

Crimminy - can't someone voice a counter position without the wrath of God
coming down ?

I am simply making a point that : 
I think it's too much to demand that all external entry points be removed.
We use them extensively for error injection, testing, diagnostics, and
troubleshooting. I don't want to push users to a vendor-specific driver just
to have these capabilities. Nor do we want to have debates on what driver is
qual'd/supported by customers and OEMS - we want 1 and only 1 driver - the
one in the base kernel.  I don't think this an unreasonable demand.  I hope
you can accurately reflect this viewpoint in your talk...


-- James


