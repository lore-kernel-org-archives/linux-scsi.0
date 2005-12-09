From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [ACPI] Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Fri, 09 Dec 2005 06:42:12 -0500
Message-ID: <43996D94.5080108@pobox.com>
References: <20051208030242.GA19923@srcf.ucam.org>	 <20051208091542.GA9538@infradead.org>	 <20051208132657.GA21529@srcf.ucam.org>	 <20051208133308.GA13267@infradead.org>	 <20051208133945.GA21633@srcf.ucam.org>	 <20051208135225.GA13122@havoc.gtf.org>	 <1134050863.17102.5.camel@localhost.localdomain>	 <43983FC6.6050108@pobox.com> <1134052257.17102.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:22960 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750970AbVLILmU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2005 06:42:20 -0500
In-Reply-To: <1134052257.17102.13.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Christoph Hellwig <hch@infradead.org>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net

Alan Cox wrote:
> On Iau, 2005-12-08 at 09:14 -0500, Jeff Garzik wrote:
> 
>>These are only for PATA.  We don't care about _GTM/_STM on SATA.
> 
> 
> Even your piix driver supports PATA. Put the foaming (justified ;))
> hatred for ACPI aside for a moment and take a look at the real world as
> it unfortunately is right now.

First, I clearly said "except on ata_piix ... or PATA"

Second, don't put words in my mouth.  I don't hate ACPI, and libata's 
direction for hotswap and suspend/resume has zero to do with "foaming 
hatred."

Right now, the top priority is getting SATA suspend/resume correct, and 
_hopefully_ doing it in a way that's friendly to PATA.  And as I said, 
we don't care about _GTM/_STM on SATA.

Further, all current ACPI proposed code is completely half-assed.  It's 
"hope and pray", because libata configures the device and does resets -- 
which is bound to CONFLICT WITH ACPI.

Even further, I want to support both ACPI cases (x86[-64]) and non-ACPI 
cases (other arches).  Some platforms want ACPI for passwords or other 
settings.  Some platforms don't have ACPI at all.  Locking libata into 
ACPI _only_ for suspend/resume is completely unacceptable.

I'm not a hope-n-pray kind of guy.  I want to get it right.  People are 
more than welcome to use unapplied patches floating around the 'net 
until we get there.

	Jeff


