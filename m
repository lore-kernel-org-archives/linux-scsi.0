From: David Miller <davem@davemloft.net>
Subject: Re: [GIT PATCH] firs round of SCSI bug fixes for 2.6.29-rc1
Date: Fri, 16 Jan 2009 11:09:31 -0800 (PST)
Message-ID: <20090116.110931.166270342.davem@davemloft.net>
References: <1232117771.3224.21.camel@localhost.localdomain>
	<20090116090928.e43c986e.akpm@linux-foundation.org>
	<1232131733.3224.46.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33460
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756035AbZAPTJ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2009 14:09:29 -0500
In-Reply-To: <1232131733.3224.46.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Fri, 16 Jan 2009 13:48:53 -0500

> On Fri, 2009-01-16 at 09:09 -0800, Andrew Morton wrote:
> > Doing a panic() after we've already detected an error is plain nasty. 
> > Is there no way in which we can allow the kernel to continue?
> 
> There's a long thread discussing this very point on linux-scsi.  The
> short version is "no, it's only used for debugging firmware and if
> you've corrupted your firmware to this point you need the machine
> halting".

Long thread or not, taking out one's entire system because one
device hits a fail state is always wrong.

If I have other block devices which are working, all I want
is for this specific controller and it's block devices to
fail.

This way I can get the failure log message and actually do something
with that data without rebooting.

Or I guess digital cameras and serial/net consoles are the only
sanctioned way to record kernel failure log messages of this kind?

Give me a break. :)
