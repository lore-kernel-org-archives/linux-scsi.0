From: Bryce Harrington <bryce@osdl.org>
Subject: Re: [OOPS] -git8,9:  NULL pointer dereference in mptspi_dv_renegotiate_work
Date: Fri, 29 Sep 2006 17:27:55 -0700
Message-ID: <20060930002755.GI12968@osdl.org>
References: <664A4EBB07F29743873A87CF62C26D70350500@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:3229 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932369AbWI3A2A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Sep 2006 20:28:00 -0400
Content-Disposition: inline
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70350500@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Sep 29, 2006 at 06:10:42PM -0600, Moore, Eric wrote:
> On Friday, September 29, 2006 3:41 PM, Bryce Harrington wrote: 
> > > Can you enable debug messages in the driver Makefile, for
> > > the line called MPT_DEBUG_CONFIG; that way we can find out which
> > > config page failed.  
> > 
> > Sure; not sure what the interesting part is, but here's the full log
> > from this:
> > 
> >    http://crucible.osdl.org/runs/2265/sysinfo/amd01.2.console
> > 
> 
> 
> Thanks.  It appears you enabled MPT_DEBUG instead of MPT_DEBUG_CONFIG.
> All the "WaitForDoorbell" debugs are from that.  Can you recheck your
> Makefile.

Does this look better?

    http://crucible.osdl.org/runs/2265/sysinfo/amd01.3.console

Bryce

