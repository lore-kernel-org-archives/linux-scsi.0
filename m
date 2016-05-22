From: Petros Koutoupis <petros@petroskoutoupis.com>
Subject: Re: scsi_common: Modify SMR device type to reflect SCSI
 specification
Date: Sun, 22 May 2016 13:11:41 -0500
Message-ID: <1463940701.5320.3.camel@petros-ultrathin>
References: <1463882319.4525.3.camel@petros-ultrathin>
	 <1463937643.2257.19.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:54700 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbcEVSLu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 May 2016 14:11:50 -0400
In-Reply-To: <1463937643.2257.19.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Petros Koutoupis <petros@petroskoutoupis.com>

On Sun, 2016-05-22 at 10:20 -0700, James Bottomley wrote:
> On Sat, 2016-05-21 at 20:58 -0500, Petros Koutoupis wrote:
> > This change is purely cosmetic but we should adjust device type 0x14 
> > to reflect the definition given in the SCSI specification standard 
> > (SPC -5).
> > 
> > Implying Direct-Access assumes that the device supports the 
> > traditional Direct-Access command set when Host Managed Zoned Block 
> > Devices support a subset of that command set with a few zone specific 
> > additions. Please refer to the ZBC for details.
> 
> This string is output via an sdev_printk.  Technically, that makes it a
> an ABI for stuff that does log parsing.  It's only a weak ABI because
> logs are somewhat changeable so it's not that we can't do this, but I'd
> like a good reason before doing it.
> 
> Can you explain why you want do do this? ... your change log is very
> vague.  I think it's because you think we should more closely reflect
> the language in table 148 (peripheral device type field) but that's not
> very convincing because none of the rest of our definitions exactly
> reflect that language either.  Plus the current definition reflects how
> RBC devices are presented, so it seems logical.
> 
> James
> 

James,

I get it. It was more of a suggestion anyway. And you are correct, my
reason was t be closer to the language of the peripheral device type field
in the inquiry string.

--
Petros

