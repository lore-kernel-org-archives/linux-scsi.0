From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: clean up endianness
Date: Sun, 15 Oct 2006 21:01:00 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0610152029080.3641@poirot.grange>
References: <Pine.LNX.4.60.0610082208090.20132@poirot.grange>
 <1160363950.3528.23.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.60.0610090747140.3756@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54412 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1422764AbWJOTBA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Oct 2006 15:01:00 -0400
In-Reply-To: <Pine.LNX.4.60.0610090747140.3756@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 9 Oct 2006, Guennadi Liakhovetski wrote:

> but don't 32-bit io[rw] routines on BE machines do the swapping internally 
> on PCI? I seem to remember having read something about that, not sure 
> any more, though. But, at least, it won't be more buggy than before:-) 
> Should I swap here?

James, I tried again to look in ppc code, and it does look like io 
operations are byte-swapped (use lwbrx and friends). If I am right, are 
there still more problems with that patch? I need to know it as I have a 
next patch, which eventually removes the bus_to_virt() from tmscsim. 
Although I still have no way to test this path.

Thanks
Guennadi
---
Guennadi Liakhovetski
