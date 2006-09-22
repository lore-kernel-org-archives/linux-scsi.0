From: "Patro, Sumant" <Sumant.Patro@lsil.com>
Subject: RE: [Patch 6/7] megaraid_sas: adds tasklet for cmd completion
Date: Thu, 21 Sep 2006 19:12:06 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E82296DF339@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:53903 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932166AbWIVBMe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Sep 2006 21:12:34 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, akpm@osdl.org, hch@lst.de, linux-kernel@vger.kernel.org, "Kolli, Neela" <Neela.Kolli@engenio.com>, "Yang, Bo" <Bo.Yang@engenio.com>

Hello Christoph,

	Thank you for the review of the patches.	
	With implementation of tasklet in the driver we see a
performance increase of about 8%, so we decided to go with it.

Regards,
Sumant

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Thursday, September 21, 2006 4:46 AM
To: Patro, Sumant
Cc: James.Bottomley@SteelEye.com; linux-scsi@vger.kernel.org;
akpm@osdl.org; hch@lst.de; linux-kernel@vger.kernel.org; Kolli, Neela;
Yang, Bo
Subject: Re: [Patch 6/7] megaraid_sas: adds tasklet for cmd completion

On Wed, Sep 20, 2006 at 07:31:29PM -0700, Sumant Patro wrote:
> This patch adds a tasklet for command completion.

Why would you need this?  The normal scsi command completion is
offloaded
to the SCSI softirq ASAP so I don't see any point for those.  Do you see
too much time spent in completion of the internal commands?

