From: Christoph Hellwig <hch@infradead.org>
Subject: Re: qla1280 endiannes and 64/32bit fixes
Date: Mon, 19 Jan 2004 17:40:27 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040119174027.B3176@infradead.org>
References: <1074382860.1756.20.camel@mulgrave> <20040118024326.GA381527@sgi.com> <1074395819.1756.31.camel@mulgrave> <20040118062157.GA11083@praka.local.home> <20040118073321.GC383498@sgi.com> <1074437655.1804.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:19468 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265555AbUASRkd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 12:40:33 -0500
Content-Disposition: inline
In-Reply-To: <1074437655.1804.12.camel@mulgrave>; from James.Bottomley@steeleye.com on Sun, Jan 18, 2004 at 09:54:13AM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jeremy Higdon <jeremy@sgi.com>, Andrew Vasquez <praka@users.sourceforge.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, jes@sgi.com

On Sun, Jan 18, 2004 at 09:54:13AM -0500, James Bottomley wrote:
> However, I have another question for you:  Does the card BIOS actually
> get to run on bootup?  It doesn't (because it can't) on PA, so I get
> strange values for certain NVRAM quantities (like the 32 bit mode, but
> more importantly, the offset of all my devices gets set to 1).  I was
> thinking about doing an override to set them more sensibly and wondered
> if you were having the same problem.

Guys, given that problems with that nvram reading stuff show up again and
again, shouldn't we rip out the code looking at the nvram completely?
Or at least disable it by default and enable it only by a module option
(for both qla1280 and qla2xxx).

