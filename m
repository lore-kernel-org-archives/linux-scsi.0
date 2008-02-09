From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: arcmsr + archttp64 calls dma_free_coherent() with irqs
	disabled - dmesg filled with warnings
Date: Sat, 09 Feb 2008 13:43:39 -0600
Message-ID: <1202586219.4254.35.camel@localhost.localdomain>
References: <47ADC74B.9080009@control.aau.dk>
	 <1202580076.4254.24.camel@localhost.localdomain>
	 <20080209193518.GC11299@hoblitt.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57758 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755055AbYBITnn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2008 14:43:43 -0500
In-Reply-To: <20080209193518.GC11299@hoblitt.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joshua Hoblitt <josh@hoblitt.com>
Cc: Kim H?jgaard-Hansen <kimhh@control.aau.dk>, erich@areca.com.tw, linux-scsi@vger.kernel.org, dsd@gentoo.org, j_gentoo@hoblitt.com


On Sat, 2008-02-09 at 09:35 -1000, Joshua Hoblitt wrote:
> Hi James,
> 
> I can give it a try.  What commit id do you think fixed it?

commit 76d78300a6eb8b7f08e47703b7e68a659ffc2053
Author: Nick Cheng <nick.cheng@areca.com.tw>
Date:   Mon Feb 4 23:53:24 2008 -0800

    [SCSI] arcmsr: updates (1.20.00.15)

James


