From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptspi : Usefull code for debuging domain validation
Date: Thu, 21 Sep 2006 16:32:32 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7032D3D3@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:19196 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932079AbWIUWir convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Sep 2006 18:38:47 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Monday, September 18, 2006 5:47 PM,  Eric Moore wrote:

> 
> Domain validation can be enabled by uncommenting MPT_DEBUG_DV
> in the driver Makefile, and recompiling.
> 
> Bump driver version to 3.04.02.
> 


James, is this debug info better suited for the spi transport layer,
or better left in fusion?

What would be nice for debuging issues would be
(1) what nego parameters were sent to device
(2) what nego parameters read back
(3) scsi commands sent during dv, and result

Another request, is can spi transport layer export a flag that would
allow lld to disable enhanced domain validation?   When dv was done
internally in fusion driver, there was a flag for this that was
configurable
in nvdata by the customer.  Some customers don't want enhanced dv.
We can pull that info into driver/transport from the spi config pages.

Eric
