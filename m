From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: PATCH: Bogus disk geometry on large disks
Date: Fri, 26 May 2006 19:22:18 +0100
Message-ID: <1148667738.20856.40.camel@localhost.localdomain>
References: <1148660965.20856.35.camel@localhost.localdomain>
	 <20060526175713.GB19587@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55690 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S1751224AbWEZSIJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 May 2006 14:08:09 -0400
In-Reply-To: <20060526175713.GB19587@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org

On Gwe, 2006-05-26 at 11:57 -0600, Matthew Wilcox wrote:
> On Fri, May 26, 2006 at 05:29:25PM +0100, Alan Cox wrote:
> >  
> > -	if (ret == -1) {
> > +	if (ret == -1 && capacity < (1ULL << 32)) {
> >  		/* pick some standard mapping with at most 1024 cylinders,
> 
> won't that provoke a gcc warning when sector_t is 32-bit?  how about ...

I don't believe it will as the type is forced to "1ULL"
