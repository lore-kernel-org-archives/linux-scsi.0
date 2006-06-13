From: "Lev A. Melnikovsky" <leva@hotmail.com>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Wed, 14 Jun 2006 01:08:46 +0400 (MSD)
Message-ID: <Pine.LNX.4.64.0606140019310.20812@nev.ubzr>
References: <Pine.LNX.4.64.0606042013200.14649@nev.ubzr>
 <Pine.LNX.4.60.0606041850090.13574@poirot.grange> <Pine.LNX.4.64.0606042201460.14649@nev.ubzr>
 <Pine.LNX.4.60.0606042022540.24306@poirot.grange> <Pine.LNX.4.64.0606051150440.4038@nev.ubzr>
 <Pine.LNX.4.60.0606051242150.4149@poirot.grange> <Pine.LNX.4.64.0606060050360.7237@nev.ubzr>
 <Pine.LNX.4.60.0606060008330.22057@poirot.grange> <Pine.LNX.4.64.0606070253580.14004@nev.ubzr>
 <Pine.LNX.4.60.0606072312410.9588@poirot.grange> <Pine.LNX.4.64.0606090054530.20041@nev.ubzr>
 <Pine.LNX.4.60.0606082349110.12855@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [212.45.14.9] ([212.45.14.9]:41978 "EHLO ari.home")
	by vger.kernel.org with ESMTP id S932225AbWFMVIn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jun 2006 17:08:43 -0400
In-Reply-To: <Pine.LNX.4.60.0606082349110.12855@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Dear Guennadi,

   On Fri, 9 Jun 2006 at 12:00am, Guennadi Liakhovetski wrote:

> Nice pic, if you took a bit further West you'd scan Vladivostok - that's
> where I come from:-)
OK, moving West :-)

http://kapitza.ras.ru/~leva/Vladik.jpg

> Well, I think, we just have to chose the right error-cods to return, 
> this controls the mid-layer bahaviour - whether to abort, or to 
> resubmit, or whatever. The error I returned (DID_SOFT_ERROR) means 
> "retry". Honestly, I don't know what's the correct error-code here. I 
> can only guess. Well, please, try DID_ABORT.
Unfortunately this does not help. The picture above was acquired using 
DID_ABORT. There's probably some minor difference in the driver behaviour 
but I can not reliably say anything yet.

> Also, you can strace the application with complete
Well, stracing sane will be the last thing I'm going to try, honestly :-)

   On Tue, 13 Jun 2006 at 6:10pm, Guennadi Liakhovetski wrote:

> Lev, an easier possibility to test if bytes are lost or repeated: just 
> scan an image several times, saving it in an UNcompressed format, then, 
> I think, the size should always be the same, right? Then you can just 
> compare which file is bigger - the correct or the damaged one.
Image compression (jpeg) does not change the image dimensions. And 
dimensions are always the same. Anyway, "sane" knows these dimensions 
beforehand...

I remember you mentioned TRM-S1040 datasheet, is it publicly available? 
How do I get one?

Thanks
-L.
