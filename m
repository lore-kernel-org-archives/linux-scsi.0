From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: arcmsr + archttp64 calls dma_free_coherent() with irqs
	disabled - dmesg filled with warnings
Date: Tue, 12 Feb 2008 16:30:36 -0600
Message-ID: <1202855436.3137.153.camel@localhost.localdomain>
References: <47ADC74B.9080009@control.aau.dk>
	 <1202580076.4254.24.camel@localhost.localdomain>
	 <20080209193518.GC11299@hoblitt.com>
	 <1202586219.4254.35.camel@localhost.localdomain>
	 <20080212205345.GB7640@hoblitt.com>  <20080212222109.GC7640@hoblitt.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:32898 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753732AbYBLWap (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2008 17:30:45 -0500
In-Reply-To: <20080212222109.GC7640@hoblitt.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joshua Hoblitt <josh@hoblitt.com>
Cc: Kim H?jgaard-Hansen <kimhh@control.aau.dk>, erich@areca.com.tw, linux-scsi@vger.kernel.org, dsd@gentoo.org, j_gentoo@hoblitt.com


On Tue, 2008-02-12 at 12:21 -1000, Joshua Hoblitt wrote:
> I've got a few compilation errors on head.  Before I try it, is it
> possible to backport the 76d78300a6eb8b7f08e47703b7e68a659ffc2053 change
> to 2.6.24.y?

I don't see any reason why not but I'd have to cherry pick it to see ...
so you could save me the bother by trying it yourself ...

James


