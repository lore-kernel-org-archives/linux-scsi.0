From: "Kolli, Neela Syam" <Neela.Kolli@engenio.com>
Subject: RE: [PATCH] Schedule removal of megaraid hardware support overlap
Date: Thu, 10 Nov 2005 10:36:09 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570751D274@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:40859 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750943AbVKJPhB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Nov 2005 10:37:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Drake <dsd@gentoo.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>, 'Christoph Hellwig' <hch@infradead.org>, linux-scsi@vger.kernel.org, "Ju, Seokmann" <Seokmann.Ju@engenio.com>

This patch is good.  Thanks for the patch.  
In the meantime, we are working on removing the hardware support overlap in
megaraid drivers.  We should be getting this patch out in coming weeks.

Thanks,
Neela Syam Kolli.


-----Original Message-----
From: Daniel Drake [mailto:dsd@gentoo.org] 
Sent: Monday, November 07, 2005 9:09 AM
To: James Bottomley
Cc: Bagalkote, Sreenivas; 'Christoph Hellwig'; Kolli, Neela Syam;
linux-scsi@vger.kernel.org; Ju, Seokmann
Subject: [PATCH] Schedule removal of megaraid hardware support overlap

Hopefully we'll be getting the build restriction zapped much sooner, but we 
should also be thinking about totally removing the hardware support overlap
in 
the megaraid drivers.

This patch pencils in a date of Feb 06 for this, and performs some printk 
abuse in hope that existing legacy users might pick up on what's going on.

Signed-off-by: Daniel Drake <dsd@gentoo.org>

