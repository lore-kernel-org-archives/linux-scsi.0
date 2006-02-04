From: "Patro, Sumant" <Sumant.Patro@lsil.com>
Subject: RE: [PATCH 2/2] megaraid_sas: support for 1078 type controlleradded
Date: Fri, 3 Feb 2006 17:03:00 -0700
Message-ID: <0631C836DBF79F42B5A60C8C8D4E82292C6937@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:29634 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751503AbWBDADK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Feb 2006 19:03:10 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, "Moore, Eric" <Eric.Moore@lsil.com>
Cc: hch@lst.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>, "Kolli, Neela" <Neela.Kolli@engenio.com>, "Yang, Bo" <Bo.Yang@engenio.com>, "Doelfel, Hardy" <Hardy.Doelfel@engenio.com>

Yes the device id issue has been resolved.

The device id has been changed for 1078 controllers for megaraid_sas to
60 
from 62.

Thanks,

Sumant


-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Friday, February 03, 2006 3:55 PM
To: Moore, Eric; Patro, Sumant
Cc: hch@lst.de; linux-kernel@vger.kernel.org;
linux-scsi@vger.kernel.org; Bagalkote, Sreenivas; Kolli, Neela; Yang,
Bo; Doelfel, Hardy
Subject: Re: [PATCH 2/2] megaraid_sas: support for 1078 type
controlleradded

On Fri, 2006-02-03 at 15:34 -0800, Sumant Patro wrote:
>         {
> +        PCI_VENDOR_ID_LSI_LOGIC,
> +        PCI_DEVICE_ID_LSI_SAS1078R, // ppc IOP
> +        PCI_ANY_ID,
> +        PCI_ANY_ID,
> +       },

I thought the fusion people objected to this because they also have a
fusion card with this id; has that now been resolved?

James


