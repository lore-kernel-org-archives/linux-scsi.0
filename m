From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fix check_region usage in eata_pio
Date: Wed, 2 Jun 2004 23:41:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040602214102.GA2689@lst.de>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD51AC@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:22505 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262431AbUFBVlR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2004 17:41:17 -0400
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD51AC@otce2k03.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Wed, Jun 02, 2004 at 09:24:40AM -0400, Salyzyn, Mark wrote:
> As one of the engineers that developed this card, the EATA ISA cards
> take 9 bytes of accessible space. I strongly recommend this patch since
> taking 8 carries with it risks.
> 
> The EISA and PCI cards took 32 and 16 bytes respectively though, which
> should not be a problem since these are (BIOS) managed resources. The
> PCI card when forced to occupy ISA addresses (170 and 1F0) typically did
> not collide with other ISA resources since most cards occupy several
> registers on even boundaries and could not be placed into the touchy +9
> to +15 region. 

Thanks a lot for the information.  I'll rework the patch to take that
into account.

You don't happen to have some of these boards still around at adaptec,
do you? :)

