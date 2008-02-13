From: "nickcheng" <nick.cheng@areca.com.tw>
Subject: RE: arcmsr + archttp64 calls dma_free_coherent() with irqsdisabled - dmesg filled with warnings
Date: Wed, 13 Feb 2008 10:08:55 +0800
Message-ID: <002201c86de5$631d1d90$8800a8c0@Nick>
References: <1202855436.3137.153.camel@localhost.localdomain>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 60-248-88-209.HINET-IP.hinet.net ([60.248.88.209]:29321 "EHLO
	areca.com.tw" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753415AbYBMCME (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2008 21:12:04 -0500
In-Reply-To: <1202855436.3137.153.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@HansenPartnership.com>, 'Joshua Hoblitt' <josh@hoblitt.com>
Cc: 'Kim H?jgaard-Hansen' <kimhh@control.aau.dk>, erich@areca.com.tw, linux-scsi@vger.kernel.org, dsd@gentoo.org, j_gentoo@hoblitt.com

Please keep me in the loop.

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Wednesday, February 13, 2008 6:31 AM
To: Joshua Hoblitt
Cc: Kim H?jgaard-Hansen; erich@areca.com.tw; linux-scsi@vger.kernel.org;
dsd@gentoo.org; j_gentoo@hoblitt.com
Subject: Re: arcmsr + archttp64 calls dma_free_coherent() with irqsdisabled
- dmesg filled with warnings


On Tue, 2008-02-12 at 12:21 -1000, Joshua Hoblitt wrote:
> I've got a few compilation errors on head.  Before I try it, is it
> possible to backport the 76d78300a6eb8b7f08e47703b7e68a659ffc2053 change
> to 2.6.24.y?

I don't see any reason why not but I'd have to cherry pick it to see ...
so you could save me the bother by trying it yourself ...

James


