From: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
Subject: RE: After memory pressure: can't read from tape anymore
Date: Sun, 05 Dec 2010 11:44:49 +0100
Message-ID: <1291545889.2814.2882.camel@larosa>
References: <1290971729.2814.13.camel@larosa>
	 <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local>
	 <1291123886.2181.1347.camel@quux.techfak.uni-bielefeld.de>
	 <4CF521DE.7020800@panasas.com>
	 <alpine.LNX.2.00.1011301821210.9731@kai.makisara.local>
	 <4CF52A03.2000704@panasas.com>
	 <alpine.LNX.2.00.1011301853300.9731@kai.makisara.local>
	 <4CF53349.10509@panasas.com>
	 <alpine.LNX.2.00.1011302139460.9731@kai.makisara.local>
	 <1291196400.2814.34.camel@larosa>
	 <B2FD678A64EAAD45B089B123FDFC3ED709113ABB@inbmail01.lsi.com>
	 <alpine.LNX.2.00.1012021807060.9213@kai.makisara.local>
	 <B2FD678A64EAAD45B089B123FDFC3ED709113B13@inbmail01.lsi.com>
	 <alpine.LNX.2.00.1012022215060.9213@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smarthost.TechFak.Uni-Bielefeld.DE ([129.70.137.17]:50547 "EHLO
	smarthost.TechFak.Uni-Bielefeld.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754601Ab0LEKox (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Dec 2010 05:44:53 -0500
In-Reply-To: <alpine.LNX.2.00.1012022215060.9213@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, Boaz Harrosh <bharrosh@panasas.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Am Donnerstag, den 02.12.2010, 22:25 +0200 schrieb Kai Makisara:

> P.S. Why is it necessary to use 2 MB blocks? Some people say that it is 
> the optimal block size for some current tape drives.

I really couldn't care less about blocksizes, but it seems to be that
it's impossible to reach high LTO4 write-speeds with lower blocksizes;
tests show that >100MiB/s are not possible with blocksizes around 64KB
to 512KB (from memory), so: the bigger the blocksize, the higher the
writing speed.

I suppose this gets even more critical with LTO5 drives.

-- 
Lukas


