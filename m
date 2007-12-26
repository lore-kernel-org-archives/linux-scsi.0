From: Cory Visi <visi@gcinfotech.com>
Subject: RE: Problems with LSI MegaRaid 1068e
Date: Wed, 26 Dec 2007 17:29:40 -0500
Message-ID: <OFBFF383A8.1EDE36E9-ON852573BD.007B76EF-852573BD.007B9123@gcinfotech.com>
References: <664A4EBB07F29743873A87CF62C26D70C0E372@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server02.globalcareers.com ([216.254.106.114]:52517 "EHLO
	server02.globalcareers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401AbXLZW3t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Dec 2007 17:29:49 -0500
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70C0E372@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, linux-scsi@vger.kernel.org, "Support, Software" <support@lsi.com>

Eric,

Sorry about the confusion and thank you very much for the references to 
other support addresses.

You may want to consider removing the support@lsi.com e-mail address from 
MAINTAINERS.  They really have no idea how to respond to Linux kernel 
driver requests.

Thank you again!

Cory Visi
Managing Partner
GC InfoTech, LLC
E-mail: visi@gcinfotech.com
Mobile: (203) 912-1173
Office: (203) 327-5700 x4103
Fax:    (203) 353-1035



"Moore, Eric" <Eric.Moore@lsi.com> 
12/26/2007 04:35 PM

To
"Cory Visi" <visi@gcinfotech.com>, "DL-MPT Fusion Linux" 
<DL-MPTFusionLinux@lsi.com>, "Support, Software" <support@lsi.com>, 
<linux-scsi@vger.kernel.org>
cc

Subject
RE: Problems with LSI MegaRaid 1068e






On Wednesday, December 26, 2007 12:39 PM,  Cory Visi wrote:

> To whom it may concern:
> 
> I am working with a SuperMicro "Super Server" AS2020A-8RB with an 
> integrated LSI MegaRaid 1068e (Firmware M1068e.01.08221427R).
> 
> The configuation uses 3x 73 GB SAS drives in a RAID 5 
> configuration (using 
> the RAID key).
> 

MegaRAID != Fusion

Please contact the MegaRAID team. I guess it will be either Sreenivas
Bagalkote(Sreenivas.Bagalkote@lsi.com) or Sumant
Patro(Sumant.Patro@lsi.com). Their contact info should be available in
the MAINTAINERS file in the top folder of the kernel source tree.

Eric


