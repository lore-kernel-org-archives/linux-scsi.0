From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [OOPS] -git8,9:  NULL pointer dereference in mptspi_dv_renegotiate_work
Date: Fri, 29 Sep 2006 18:10:42 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70350500@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:3777 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1422800AbWI3AKr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Sep 2006 20:10:47 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryce Harrington <bryce@osdl.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Friday, September 29, 2006 3:41 PM, Bryce Harrington wrote: 
> > Can you enable debug messages in the driver Makefile, for
> > the line called MPT_DEBUG_CONFIG; that way we can find out which
> > config page failed.  
> 
> Sure; not sure what the interesting part is, but here's the full log
> from this:
> 
>    http://crucible.osdl.org/runs/2265/sysinfo/amd01.2.console
> 


Thanks.  It appears you enabled MPT_DEBUG instead of MPT_DEBUG_CONFIG.
All the "WaitForDoorbell" debugs are from that.  Can you recheck your
Makefile.

Thanks,
Eric
