From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: [patch 18/24] megaraid: Dell CERC ATA100/4ch support
Date: Wed, 27 Sep 2006 07:48:57 -0600
Message-ID: <890BF3111FB9484E9526987D912B261932E3A0@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:45792 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932155AbWI0Nt0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Sep 2006 09:49:26 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: akpm@osdl.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

> Will you accept a patch that limits PCI IDs with VID=101E, 
> DID=1960 and 
> SSVID=1028 in the new driver to exactly three models specified in its 
> source file comments and, on the other hand, adds PCI ID of Dell CERC 
> ATA100/4ch to the old driver?
I've forwarded your request to program management team. But, I don't think it will be accepted.
Technically, I would recommend you to check F/W version and make sure it is not higher than 6.61.
I believe the problem happens with 6.62 or higher.

Thank you, 

> -----Original Message-----
> From: Janusz Krzysztofik [mailto:jkrzyszt@tis.icnet.pl] 
> Sent: Wednesday, September 27, 2006 6:39 AM
> To: Ju, Seokmann
> Cc: akpm@osdl.org; James.Bottomley@steeleye.com; 
> linux-scsi@vger.kernel.org
> Subject: Re: [patch 18/24] megaraid: Dell CERC ATA100/4ch support
> 
> Ju, Seokmann wrote:
> > Hi,
> > On Tuesday, August 15, 2006 2:10 AM, Janusz Krzysztofik wrote:
> >> Add CERC subsystem ids to the old megaraid driver.  Tested, works.
> > NACK - This addition will create PCI ID overlapping with 
> megaraid_{mbox,mm} module under driver/scsi/megaraid.
> > Since 2.6.16, we have removed some IDs in the megaraid 
> module under driver/scsi to address ID overlappijng issue.
> > Please switch to megaraid_{mbox,mm} module for the 
> controller support. megaraid module under driver/scsi is 
> dedicated to very old products.
> > 
> > Seokmann
> 
> Hi,
> 
> Dell CECR ATA100/4ch does not work with the new megaraid_mbox 
> driver for 
> me. The adapter is recognized, but it does not show any virtual nor 
> physical drives. I have no skills to correct the problem. 
> Furthermore, I 
> have found some comments on this hardware no longer supported 
> by Dell, 
> RedHat, etc.
> 
> Will you accept a patch that limits PCI IDs with VID=101E, 
> DID=1960 and 
> SSVID=1028 in the new driver to exactly three models specified in its 
> source file comments and, on the other hand, adds PCI ID of Dell CERC 
> ATA100/4ch to the old driver?
> 
> Janusz
> 
> 
