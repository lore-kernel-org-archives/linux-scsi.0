From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: Ultra320 drive detected as narrow SCSI by adapter
Date: Mon, 25 Sep 2006 09:57:10 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7032D7DA@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:1953 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751050AbWIYP5N convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 11:57:13 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Israel Mouton <lebanon87@myrealbox.com>, linux-scsi@vger.kernel.org

On Sunday, September 24, 2006 10:47 PM, Israel Mouton wrote: 

> 
> It is 2.6.16; however, it is the Debian version.  I did 
> compile it from
> source.  Perhaps there is a chance I left something unchecked 
> I should have
> compiled in?
> 


If your using the driver having spi transport support,
it will be calling spi_dv_device from mptspi.c; can
you grep the source code?

If your using the older driver not having spi
transport support, then you are using a driver
where domain validation was implementing inside
the driver. In that case, I ask that you enable
the MPT_DEBUG_DV and MPT_DEBUG_NEGO from the driver
Makefile, and recompile, sending me the output.

In addition, if your having BIOS on your hba,
can you go into the bios configuration utilitity
and restore the defaults?

Thanks,
Eric Moore
LSI Logic
