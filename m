From: stefan@mdy.univie.ac.at (Stefan Boresch)
Subject: Re: [PATCH] scsi_transport_spi: fix domain validation failure from incorrect width setting
Date: Mon, 24 Sep 2007 14:10:04 +0200
Message-ID: <20070924121004.GR1606@loop.mdy.univie.ac.at>
References: <1190468409.3347.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from epsilon.mdy.univie.ac.at ([131.130.40.18]:53847 "EHLO
	epsilon.mdy.univie.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753433AbXIXMKL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2007 08:10:11 -0400
Content-Disposition: inline
In-Reply-To: <1190468409.3347.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


Dear James!

Sorry for replying so late!

On Sat, Sep 22, 2007 at 08:40:09AM -0500, James Bottomley wrote:
> The previous patch was a bit non-standard because it actually adjusted
> the user setting max_width.  This would mean that if the user replaced
> the cable and then re-ran domain validation, it still wouldn't try wide
> transfers, which is wrong.
> 
> The attached patch fixes the problem by physically nailing the wide
> setting to what it deduces it should be for the whole of Domain
> Validation.
> 
> James
> 
> diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
[snip]

A self-compiled kernel based on the Ubuntu "gutsy" kernel sources
(linux-source-2.6.22_2.6.22-12.36_all.deb, for whatever that is worth) boots
successfully, after applying your patch (which applied cleanly)

Thanks so much for your help,

Stefan Boresch

PS: BTW, your original post (diagnosis of hardware issues) has also
convinced my vendor to do some work to honor his warranty. So, my next
job is to dig into the big box which just arrived by fed-ex containing
all possible replacements (including a new motherboard ..). Maybe,
I'll eventually get U320 running on this machine ;-)

-- 
Stefan Boresch
Institute for Computational Biological Chemistry
University of Vienna, Waehringerstr. 17       A-1090 Vienna, Austria
Phone: -43-1-427752715                        Fax:   -43-1-427752790
