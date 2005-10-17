From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Fw: slab error in cache_free_debugcheck(): cache `sgpool-8':
Date: Mon, 17 Oct 2005 22:26:28 +0200
Message-ID: <435408F4.4090907@s5r6.in-berlin.de>
References: <20051017002339.5156d7f4.akpm@osdl.org> <4353754B.1040500@s5r6.in-berlin.de> <4353FDAD.1010204@chello.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:51677 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751343AbVJQU2q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 16:28:46 -0400
In-Reply-To: <4353FDAD.1010204@chello.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
Cc: "F. Poncin" <cr27587@chello.be>, Andrew Morton <akpm@osdl.org>

F. Poncin wrote:
> Brand new Seagate USB/FireWire External Hard Drive - 
> http://www.seagate.com/products/personal/external.html
> Connected through FireWire to PCI card: FireWire (IEEE 1394): Agere 
> Systems (former Lucent Microelectronics) FW323 (rev 61)
> 
> The older Seagate model (same size) is not affected.
> Vendor: ST340083 Model: 2A Rev:
> Type: Direct-Access-RBC ANSI SCSI revision: 04
...
>>> scsi2 : SCSI emulation for IEEE-1394 SBP-2 Devices
>>> ieee1394: sbp2: Logged into SBP-2 device
>>> ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
>>> Vendor: Initio Model: ST3400832A Rev: 4.07
>>> Type: Direct-Access ANSI SCSI revision: 00

I suspect that most of these alleged Direct-Access FireWire bridges are 
actually more or less Direct-Access-RBC bridges. I have two bridges that 
report to be of the Direct-Access type; the Initio based one (although 
1394b/S800, not 1394a like yours) and an older based on TI StorageLynx. 
Both feature different firmware quirks.
-- 
Stefan Richter
-=====-=-=-= =-=- =---=
http://arcgraph.de/sr/
