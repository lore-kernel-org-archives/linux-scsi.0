From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: mvsas errors in 2.6.36
Date: Tue, 7 Dec 2010 11:30:46 -0500
Message-ID: <20101207163046.GD31592@kvack.org>
References: <201010290650.32892.thomas@fjellstrom.ca> <4CE3912E.6060904@tomt.net> <201012012329.54944.thomas@fjellstrom.ca> <201012020249.00367.thomas@fjellstrom.ca> <4CF79C60.9030107@shiftmail.org> <AANLkTinVK8FAApP2zP8gqmPhgPo4ZeUMRRJ4cD+O1iza@mail.gmail.com> <alpine.DEB.1.10.1012051156400.9121@uplift.swm.pp.se> <AANLkTimShdYvutSH-_mzZmSdgkFGOojjs-w+CDiMRCQq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:50668 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab0LGRCW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Dec 2010 12:02:22 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTimShdYvutSH-_mzZmSdgkFGOojjs-w+CDiMRCQq@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Audio Haven <audiohaven@gmail.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Dec 06, 2010 at 12:11:11PM +0100, Audio Haven wrote:
> No issues appear in dmesg. Notice the difference in Hitachi disks
> (very high numbers, likely the actual raw error rate before error
> correction, both are Hitachi HDT721010SLA360) vs Samsung disks (only
> the unrecoverable, SAMSUNG HD103SI -> they lie, shouldn't be named
> 'raw').

This appears to have been the problem I was having after adding in the 
PCI ids for the HighPoint 2720s.  So far I've been running tests on 
2.6.37-rc4+ for the past day without any device errors which is a good 
sign.

		-ben
