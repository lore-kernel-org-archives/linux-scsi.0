From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH update] SCSI: update Kconfig help text to indicate SCSI
 core's widespread usage
Date: Sat, 15 Sep 2007 15:19:36 +0200
Message-ID: <46EBDBE8.6070201@s5r6.in-berlin.de>
References: <20070912224655.GC3563@stusta.de> <46EAA08F.30703@s5r6.in-berlin.de> <20070914151522.GL3563@stusta.de> <46EAAAC1.3050409@s5r6.in-berlin.de> <tkrat.d922469e152fe0f3@s5r6.in-berlin.de> <20070914185434.GD5386@csclub.uwaterloo.ca> <tkrat.e1d898d6a272d681@s5r6.in-berlin.de> <20070914202102.GE5386@csclub.uwaterloo.ca> <tkrat.f4379d6e5f1ce499@s5r6.in-berlin.de> <tkrat.0e73b94c1e80a481@s5r6.in-berlin.de> <20070915125924.GR3563@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:39451 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbXIONU5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Sep 2007 09:20:57 -0400
In-Reply-To: <20070915125924.GR3563@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, James Bottomley <james.bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Fri, Sep 14, 2007 at 11:14:21PM +0200, Stefan Richter wrote:
>> +	  You need it
>> +	  - for classic parallel SCSI hardware,
>> +	  - for newer SCSI transports such as Fibre Channel, FireWire storage,
>> +	    SAS, or iSCSI,
>> +	  - for non-SCSI hardware which speaks SCSI protocols, such as USB
>> +	    storage devices or the parallel port version of Iomega Zip drive,
> 
> 
> but not for CONFIG_BLK_DEV_UB
> 
> 
>> +	  - for non-SCSI hardware whose drivers translate from and to SCSI
>> +	    protocols, most notably all Serial ATA drivers, and Parallel ATA
>> +	    via the ATA configuration option.
> 
> 
> but not for CONFIG_BLK_DEV_IDE_SATA

Well, one could add a

	You don't need it
	- for x,
	- for y.

bullet list.

...
> You expect all kconfig users to read and completely understand this?

I occasionally write documentation without the expectation that every
potential user will read and understand it.

> Although it's no longer required that the user sees the CONFIG_SCSI 
> option at all since we can determine automaically when it's required
> and when not?

Maybe you can hide CONFIG_SCSI, but you still need to provide the above
information --- then under the sd, sr, st, sg options, which may
actually be the better places although it increases redundancy.
-- 
Stefan Richter
-=====-=-=== =--= -====
http://arcgraph.de/sr/
