From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: What still uses the block layer?
Date: Tue, 16 Oct 2007 22:56:14 +0200
Message-ID: <4715256E.4050609@s5r6.in-berlin.de>
References: <200710112011.22000.rob@landley.net> <200710141836.55211.rob@landley.net> <4712FE33.3000400@s5r6.in-berlin.de> <200710150426.04924.rob@landley.net> <20071015160800.GA324@parisc-linux.org> <47139F15.7050702@s5r6.in-berlin.de> <Pine.LNX.4.64.0710151954550.3949@asgard.lang.hm> <20071016111911.30a18e12@the-village.bc.nu> <Pine.LNX.4.64.0710161238140.6995@asgard.lang.hm> <20071016195432.GA31306@parisc-linux.org> <20071016203449.GA1314@closure.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:41427 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934926AbXJPU4y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2007 16:56:54 -0400
In-Reply-To: <20071016203449.GA1314@closure.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, Matthew Wilcox <matthew@wil.cx>, david@lang.hm, Alan Cox <alan@lxorguk.ukuu.org.uk>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Rob Landley <rob@landley>

Theodore Tso wrote:
> Yet another reason why people who desperately are trying to cling to
> the good old days of stable device enumerations are going to be
> disappointed;

Sure enough; stable device enumeration is a thing of the past.

This doesn't have to stop us though from providing speaking default
names for device files, just like we already provide speaking default
names for network interfaces.  (Not for all, but for many.)
-- 
Stefan Richter
-=====-=-=== =-=- =----
http://arcgraph.de/sr/
