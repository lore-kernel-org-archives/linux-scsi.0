From: Ingo Korb <nospam@akana.de>
Subject: Re: Kernel 2.6.x hangs with Symbios Logic 53c1010 Ultra3 SCSI
	Adapter
Date: Sat, 27 Nov 2004 20:52:33 +0100
Message-ID: <ur7mf2hoe.fsf@dragon.akana.de>
References: <04Nov8.094419est.332239@cyborg.cybernetics.com>
	<1099928314.10944.81.camel@compaq-rhel4.xsintricity.com>
	<41A294C5.8040702@babut.net>
	<20041123014049.GH25636@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from snowcat.de ([213.146.167.7]:23302 "EHLO snowcat.de")
	by vger.kernel.org with ESMTP id S261318AbUK0Twp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Nov 2004 14:52:45 -0500
In-Reply-To: <20041123014049.GH25636@parcelfarce.linux.theplanet.co.uk> (Matthew
 Wilcox's message of "Tue, 23 Nov 2004 01:40:49 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Thomas Babut <thomas@babut.net>, linux-scsi@vger.kernel.org

Matthew Wilcox <matthew@wil.cx> writes:

> On Tue, Nov 23, 2004 at 02:39:17AM +0100, Thomas Babut wrote:
>> Perhaps someone could make a patch for Kernel 2.6 which adds the old driver.
>
> No.  Don't do this.  Help make sym2 work for your system.

So what can one do? My Alphastation 200 has a 53C810 rev. 02 that only works
with the ncr53c8xx-driver from 2.4, sym53c8xx_2 just hangs. Details were
posted here about two weeks ago, without any replies.

-ik

