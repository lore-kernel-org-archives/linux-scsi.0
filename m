From: John Bradford <john@grabjohn.com>
Subject: Re: Binary-only firmware covered by the GPL?
Date: Fri, 26 Mar 2004 09:12:39 GMT
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200403260912.i2Q9CdLU000531@81-2-122-30.bradfords.org.uk>
References: <E1B6Izr-0002Ai-00@r063144.stusta.swh.mhn.de>
 <20040325082949.GA3376@gondor.apana.org.au>
 <20040325220803.GZ16746@fs.tum.de>
 <40635DD9.8090809@pobox.com>
 <20040326003339.GD25059@parcelfarce.linux.theplanet.co.uk>
 <81ptb0wh45.wl@omega.webmasters.gr.jp>
 <4063EFA5.5070001@stesmi.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 81-2-122-30.bradfords.org.uk ([81.2.122.30]:11648 "EHLO
	81-2-122-30.bradfords.org.uk") by vger.kernel.org with ESMTP
	id S263981AbUCZJNt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Mar 2004 04:13:49 -0500
In-Reply-To: <4063EFA5.5070001@stesmi.com>
List-Id: linux-scsi@vger.kernel.org
To: Stefan Smietanowski <stesmi@stesmi.com>, GOTO Masanori <gotom@debian.or.jp>
Cc: Matthew Wilcox <willy@debian.org>, Jeff Garzik <jgarzik@pobox.com>, Adrian Bunk <bunk@fs.tum.de>, 239952@bugs.debian.org, debian-devel@lists.debian.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> > But think about: why can we distribute assembler only code in linux
> > kernel?  It's near to binary form (objdump -d is your friend).
> 
> It's not. The difference is that we can always insert another asm
> statement anywhere (of course changing the way the function works)
> and still have it assemble and unless we goofed up it'll still run.
> mov ax,ax for instance won't do a thing. We can insert that
> anywhere we wish without changing anything. The assembler will take
> care of any relative jumps and pointers but with a binary firmware,
> try to insert a byte into it (not CHANGE one, INSERT one), even
> if you know just insert a NOP somewhere - and see what happens.

Then why didn't the original programmer leave a patch space to allow
for such modifications?  Surely that could be considered part of the
'preferred form'.

John.
