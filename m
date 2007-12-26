From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: Problems with LSI MegaRaid 1068e
Date: Wed, 26 Dec 2007 15:39:12 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70C0E385@NAMAIL4.ad.lsil.com>
References: <OFBFF383A8.1EDE36E9-ON852573BD.007B76EF-852573BD.007B9123@gcinfotech.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:57506 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbXLZWjv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Dec 2007 17:39:51 -0500
Content-class: urn:content-classes:message
In-Reply-To: <OFBFF383A8.1EDE36E9-ON852573BD.007B76EF-852573BD.007B9123@gcinfotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Cory Visi <visi@gcinfotech.com>
Cc: DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, linux-scsi@vger.kernel.org, "Support, Software" <support@lsi.com>

The mptsas driver is not intended to work with MegaRAID product.  What
you need is either megasas, megasr, or some other driver with the words
"mega" in its name.   The Software Support email id is for handling
channel market, which I believe is correct for your situation.  If your
with an oem like IBM, Dell, HP, Sun, etc, let me know in private email,
and I will get you in contact with the correct product support lines.

Eric

> -----Original Message-----
> From: Cory Visi [mailto:visi@gcinfotech.com] 
> Sent: Wednesday, December 26, 2007 3:30 PM
> To: Moore, Eric
> Cc: DL-MPT Fusion Linux; linux-scsi@vger.kernel.org; Support, Software
> Subject: RE: Problems with LSI MegaRaid 1068e
> 
> Eric,
> 
> Sorry about the confusion and thank you very much for the 
> references to 
> other support addresses.
> 
> You may want to consider removing the support@lsi.com e-mail 
> address from 
> MAINTAINERS.  They really have no idea how to respond to Linux kernel 
> driver requests.
> 
> Thank you again!
> 
> Cory Visi
> Managing Partner
> GC InfoTech, LLC
> E-mail: visi@gcinfotech.com
> Mobile: (203) 912-1173
> Office: (203) 327-5700 x4103
> Fax:    (203) 353-1035
> 
> 
> 
> "Moore, Eric" <Eric.Moore@lsi.com> 
> 12/26/2007 04:35 PM
> 
> To
> "Cory Visi" <visi@gcinfotech.com>, "DL-MPT Fusion Linux" 
> <DL-MPTFusionLinux@lsi.com>, "Support, Software" <support@lsi.com>, 
> <linux-scsi@vger.kernel.org>
> cc
> 
> Subject
> RE: Problems with LSI MegaRaid 1068e
> 
> 
> 
> 
> 
> 
> On Wednesday, December 26, 2007 12:39 PM,  Cory Visi wrote:
> 
> > To whom it may concern:
> > 
> > I am working with a SuperMicro "Super Server" AS2020A-8RB with an 
> > integrated LSI MegaRaid 1068e (Firmware M1068e.01.08221427R).
> > 
> > The configuation uses 3x 73 GB SAS drives in a RAID 5 
> > configuration (using 
> > the RAID key).
> > 
> 
> MegaRAID != Fusion
> 
> Please contact the MegaRAID team. I guess it will be either Sreenivas
> Bagalkote(Sreenivas.Bagalkote@lsi.com) or Sumant
> Patro(Sumant.Patro@lsi.com). Their contact info should be available in
> the MAINTAINERS file in the top folder of the kernel source tree.
> 
> Eric
> 
> 
> 
