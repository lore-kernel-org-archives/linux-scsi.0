From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: thin provisioned LUN support
Date: Fri, 7 Nov 2008 12:48:08 -0700
Message-ID: <20081107194807.GI15439@parisc-linux.org>
References: <20081107120534.GO21867@kernel.dk> <1226072970.15281.46.camel@think.oraclecorp.com> <yq1r65na5ll.fsf@sermon.lab.mkp.net> <1226074002.8030.33.camel@localhost.localdomain> <1226074270.15281.50.camel@think.oraclecorp.com> <1226074710.8030.43.camel@localhost.localdomain> <1226078535.15281.63.camel@think.oraclecorp.com> <4914846C.5060103@redhat.com> <20081107183636.GB29717@mit.edu> <49149A88.4060902@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40820 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbYKGTsJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 14:48:09 -0500
Content-Disposition: inline
In-Reply-To: <49149A88.4060902@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jim owens <jowens@hp.com>
Cc: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>, Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>

On Fri, Nov 07, 2008 at 02:44:08PM -0500, jim owens wrote:
> To do that you kind of have to build a filesystem into the
> block layer to persistently store "mapped/unmapped blocks
> in chunk" and then do the "unmap-this-chunk" when a region
> is all unmapped.
> 
> 250 MB per 1TiB 512b sector disk for a simple 1-bit-per-sector
> state.  And that assumes you don't replicate it for safety.
> That is what the array vendors are trying to avoid by pushing
> it off to the OS.

And it's what the OS people are trying to avoid having to incorporate
by pushing back on the array vendors.

> Whoever supports thin provisioning better get their unmapping
> correct because those big customers will be looking for who
> to blame if they don't get all the features.

It's fairly clear that it's the array vendors at fault here.  They've
designed a shitty product and they're trying to get us to compensate.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
