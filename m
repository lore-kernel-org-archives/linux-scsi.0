From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptspi : Bug fix to prevent infinite nested domainvalidation
Date: Tue, 19 Sep 2006 13:02:29 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7032CD74@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:3804 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751933AbWISTCg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 15:02:36 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>, James Bottomley <James.Bottomley@SteelEye.com>, markh@osdl.org
Cc: linux-scsi@vger.kernel.org

On Tuesday, September 19, 2006 12:54 PM, Moore, Eric wrote: 

> 
> Will the dv thread that issed the host reset, wait for the lld host
> reset to complete
> itself before going forward? If not, dv will repeat itself.
> 

It just dawned on me, mptspi_dv_renegotiate_work is a work thread, so
calling spi_dv_device is done outside of eh threads that is 
handling the failing device.

Eric
