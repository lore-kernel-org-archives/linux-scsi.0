From: Matthew Wilcox <willy@debian.org>
Subject: Re: many-disk support
Date: Mon, 29 Dec 2003 14:27:07 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031229142707.GI12479@parcelfarce.linux.theplanet.co.uk>
References: <20031229022549.50bae6d7.akpm@osdl.org> <20031229110603.A27408@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:14816 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263447AbTL2O1K
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Dec 2003 09:27:10 -0500
Content-Disposition: inline
In-Reply-To: <20031229110603.A27408@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Badari Pulavarty <pbadari@us.ibm.com>, "viro@parcelfarce.linux.theplanet.co.uk" <viro@parcelfarce.linux.theplanet.co.uk>

On Mon, Dec 29, 2003 at 11:06:04AM +0000, Christoph Hellwig wrote:
> On Mon, Dec 29, 2003 at 02:25:49AM -0800, Andrew Morton wrote:
> > Guys, I've had this patch for ages.  Badari seemed to say that it wasn't
> > the "right" way to do it.
> > 
> > Can we get this nailed down please?
> 
>  - I think the bitmap overhead was killing us on big x86 machines, right?
>    so that might need some swork.
>  - a config option definitly is the wrong way to go.
>  - I don't think assigning more numbers to the last major is a bad idea,
>    better assign them to the first one, maybe with a hole for what we're
>    using the other majors currently for, so when udev gets more mature
>    we can kill the additional majors.

LWN were kind enough to archive my previous thoughts on this at
http://lwn.net/Articles/54840/

I'd've worked on some code for this if anyone had been interested ...

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
