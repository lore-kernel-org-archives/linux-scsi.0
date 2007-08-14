From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 1/6] mpt fusion: Add support for ATTO 4LD: Rebranded LSI 53C1030
Date: Tue, 14 Aug 2007 17:04:33 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7091680E@NAMAIL4.ad.lsil.com>
References: <20070814224354.GA17634@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:52329 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbXHNXEv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2007 19:04:51 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070814224354.GA17634@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Tuesday, August 14, 2007 4:44 PM,  Christoph Hellwig wrote:
> 
> Not that we can change it anymore, but what idiot decided to do such
> a change?  An chance LSI could stop licencees from doing such bloody
> braindamaged things to the firmware in the future?
> 
> add a reminder for anyone to never but ATTO hardware as the company
> is utterly useles..
>

I really not sure the significance of that change to spi_device config
pages.  My guess that atto flags have something significant to some
other OS, like windows.  I couldn't find anyone from ATTO that would
answer my doubts.   There are some customers that want PCI EXPRESS U320
card, and LSI never decided to make anything beyond xscale. There is
this express  card from ATTO, as well as one from HP, both having the
LSI 1030 chip.  LSI managment approved this request for this patch, so
we pushed forward with supplying this changeset.

I have reposted the patch per Wilcox's request having the ATTO ids, but
I just don't see it posted to the forum.  I may have to repost.

Eric  
