From: Mark Haverkamp <markh@osdl.org>
Subject: RE: [PATCH] (7/27) *really* dumb typo in aacraid (cast to pointer
	to structure that doesn't exist ;-)
Date: Wed, 02 Feb 2005 13:35:57 -0800
Message-ID: <1107380157.10645.11.camel@markh1.pdx.osdl.net>
References: <60807403EABEB443939A5A7AA8A7458BBD6089@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from fire.osdl.org ([65.172.181.4]:64944 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S262591AbVBBVgJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Feb 2005 16:36:09 -0500
In-Reply-To: <60807403EABEB443939A5A7AA8A7458BBD6089@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@adaptec.com>
Cc: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>, Linus Torvalds <torvalds@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2005-02-02 at 16:32 -0500, Salyzyn, Mark wrote:
> Cool! A good catch that could only be caught with many eyes looking at
> the code.
> 
> Wasn't in my branch though, but it looks like a common typo ;-/. 

It was my fault.  I was asked to take the cast out but when I did I got
a compile warning.  When I put it back in, I made a typo. The c and v
keys are close together :-) I don't recall seeing a warning.  


> But the
> sad part of this is that I use casts around voids to improve type
> checking (and enforce/document intentions) and it now appears to be a
> waste. I assume you did not see a warning message from your compile
> environment, right?
> 
> Sincerely -- Mark Salyzyn
> 
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Al Viro
> Sent: Wednesday, February 02, 2005 2:14 PM
> To: Linus Torvalds
> Cc: linux-scsi@vger.kernel.org
> Subject: [PATCH] (7/27) *really* dumb typo in aacraid (cast to pointer
> to structure that doesn't exist ;-)
> 
> 	spot the typo...  It's harmless, in a sense that code compiles
> right,
> but...
[...]
-- 
Mark Haverkamp <markh@osdl.org>

