From: john stultz <johnstul@us.ibm.com>
Subject: Re: Fw: [Bugme-new] [Bug 5998] New: oops on mount "kernel access
	of bad area, sig: 11 [#1]"
Date: Mon, 06 Feb 2006 11:54:13 -0800
Message-ID: <1139255653.10057.166.camel@cog.beaverton.ibm.com>
References: <20060202150719.0dafc8ae.akpm@osdl.org>
	 <43E306AC.60004@s5r6.in-berlin.de>
	 <1138993250.10057.125.camel@cog.beaverton.ibm.com>
	 <43E4912F.6090908@s5r6.in-berlin.de>
	 <20060205212809.GJ22002@conscoop.ottawa.on.ca>
	 <43E68511.2030908@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:56033 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S932337AbWBFTyR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2006 14:54:17 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k16JsGAa001248
	for <linux-scsi@vger.kernel.org>; Mon, 6 Feb 2006 14:54:16 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k16Jufuj074004
	for <linux-scsi@vger.kernel.org>; Mon, 6 Feb 2006 12:56:41 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k16JsEsD028244
	for <linux-scsi@vger.kernel.org>; Mon, 6 Feb 2006 12:54:15 -0700
In-Reply-To: <43E68511.2030908@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jody McIntyre <scjody@modernduck.com>, Andrew Morton <akpm@osdl.org>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Mon, 2006-02-06 at 00:06 +0100, Stefan Richter wrote:
> Jody McIntyre wrote:
> > On Sat, Feb 04, 2006 at 12:34:07PM +0100, Stefan Richter wrote:
> >>Linux 2.6.15 contains it, but I don't know into which -rc it went.
> > 
> > -rc3.  John, don't bother checking.  It's in there :)
> 
> Yes, indeed. _If_ we are all talking about Linus' tree here. Are we? :-)

Yes, it was Linus' tree. Although I was pulling w/ git, so it was from
somewhere between 2.6.15-rc5 and 2.6.15.

thanks
-john

