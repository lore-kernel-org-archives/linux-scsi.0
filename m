From: Christoph Hellwig <hch@infradead.org>
Subject: Re: lots and lots of disks again
Date: Tue, 10 Feb 2004 15:52:03 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040210155203.A5238@infradead.org>
References: <20040204024512.5bf68428.akpm@osdl.org> <20040210110417.GB4010@tpkurt.garloff.de> <20040210112658.GC4010@tpkurt.garloff.de> <20040210133932.A3870@infradead.org> <20040210154751.GH4010@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:17932 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265945AbUBJPwK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 10:52:10 -0500
Content-Disposition: inline
In-Reply-To: <20040210154751.GH4010@tpkurt.garloff.de>; from garloff@suse.de on Tue, Feb 10, 2004 at 04:47:51PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Badari Pulavarty <pbadari@us.ibm.com>, Matthew Wilcox <willy@debian.org>, James Bottomley <James.Bottomley@steeleye.com>

On Tue, Feb 10, 2004 at 04:47:51PM +0100, Kurt Garloff wrote:
> 
> Right, Matthew provided the reverse mapping, despite the fact that
> we don't need them, as it's just done by pointer deref ...
> 
> We may need them later though, if we ever go for 64 partitions per disk.
> So I left them in. Probably we should comment them out, so the compiler
> does not see them for now. Or stick them in the docu.

Please don't add #if 0'ed code.  Just leave it out and whoever needs it
can readd it.  

> +#define SD_DISKS	32768	// anything between 256 and 262144

Even if C99 allows C++-style comments now please don't use the in the kernel

Else I'm okay with the patch although I'm not too happy with having the
huge array, but I think we can declare that a "who complains may fix it"
issue.
