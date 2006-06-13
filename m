From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Tue, 13 Jun 2006 18:10:56 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0606131808030.4412@poirot.grange>
References: <Pine.LNX.4.64.0606042013200.14649@nev.ubzr>
 <Pine.LNX.4.60.0606041850090.13574@poirot.grange> <Pine.LNX.4.64.0606042201460.14649@nev.ubzr>
 <Pine.LNX.4.60.0606042022540.24306@poirot.grange> <Pine.LNX.4.64.0606051150440.4038@nev.ubzr>
 <Pine.LNX.4.60.0606051242150.4149@poirot.grange> <Pine.LNX.4.64.0606060050360.7237@nev.ubzr>
 <Pine.LNX.4.60.0606060008330.22057@poirot.grange> <Pine.LNX.4.64.0606070253580.14004@nev.ubzr>
 <Pine.LNX.4.60.0606072312410.9588@poirot.grange> <Pine.LNX.4.64.0606090054530.20041@nev.ubzr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.21]:13530 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932163AbWFMQK5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jun 2006 12:10:57 -0400
In-Reply-To: <Pine.LNX.4.64.0606090054530.20041@nev.ubzr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Lev A. Melnikovsky" <leva@hotmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-scsi@vger.kernel.org

On Fri, 9 Jun 2006, Lev A. Melnikovsky wrote:

> operation. A funny artifact though can be seen at the picture (this is a
> ~800KB map of Japan http://kapitza.ras.ru/~leva/Japan.jpg ). It looks like
> during each reselect a chunk of data is lost (or maybe transferred twice?) and
> the data stream gets an offset. My understanding is that the scan data are
> 8bits per color component which gives 24bits/pixel.

Lev, an easier possibility to test if bytes are lost or repeated: just 
scan an image several times, saving it in an UNcompressed format, then, I 
think, the size should always be the same, right? Then you can just 
compare which file is bigger - the correct or the damaged one.

Thanks
Guennadi
---
Guennadi Liakhovetski
