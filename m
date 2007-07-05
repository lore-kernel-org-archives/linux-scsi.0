From: "Seokmann Ju" <seokmann.ju@qlogic.com>
Subject: RE: NPIV mapping problems (was Re: [PATCH 1/19] add data buffer accessors)
Date: Thu, 5 Jul 2007 10:43:14 -0700
Message-ID: <A6970E9A290F3F4682E1EAD0EA14F32B01293066@AVEXCH2.qlogic.org>
References: <20070512182805L.fujita.tomonori@lab.ntt.co.jp><1178980728.3723.8.camel@mulgrave.il.steeleye.com><20070629132332.GB2648@plap.qlogic.org> <20070704172536N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:49143 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185AbXGERon convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2007 13:44:43 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070704172536N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, hch@infradead.org, Andrew Vasquez <andrew.vasquez@qlogic.com>

On Wed, 2007-07-04 at 1:26 +0900, FUJITA Tomonori wrote:
> On Fri, 29 Jun 2007 06:23:32 -0700 Andrew Vasquez wrote:
> > One possiblity (the least intrusive) would be to add a
> > scsi_dma_map_with_device() function which takes the proper (LLD
> > defined) 'struct device' as a parameter, as was originally 
> proposed, 
> > and have NPIV-aware drivers call that function during the 
> mappings of 
> > physical *and* virtual dma-mappings.
> 
> It's ok. But if only NPIV-aware drivers need to handle this, 
> would it be better to just use dma_map_sg instead of scsi_dma_map?
I agree with you on the suggestion.
A patch for NPIV support on qla2xxx module that includes this change
will be followed.

Seokmann
