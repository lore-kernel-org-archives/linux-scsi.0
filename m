From: Olivier Galibert <galibert@limsi.fr>
Subject: Re: AIC7xxx LUN enumeration failure and DV config failure
Date: Thu, 18 Sep 2003 13:44:22 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030918114422.GA82516@dspnet.fr.eu.org>
References: <20030917130656.GA2948@m23.limsi.fr> <20030917082359.A23802@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dspnet.fr.eu.org ([62.73.5.179]:6925 "EHLO dspnet.fr.eu.org")
	by vger.kernel.org with ESMTP id S261198AbTIRLoX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Sep 2003 07:44:23 -0400
Content-Disposition: inline
In-Reply-To: <20030917082359.A23802@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Sep 17, 2003 at 08:23:59AM -0700, Patrick Mansfield wrote:
> The following looks like 2.6.x output, since 2.4.x does not have REPORT
> LUN support.

And it is.  I had a blonde moment I guess and booted with the wrong
kernel.  2.4.23p4 works perfectly well.


> My guess is that something is totally screwed up with the arrays REPORT
> LUN results.
> 
> Does it work OK if you turn off CONFIG_SCSI_REPORT_LUNS?

I'll see when I can try that.


> If you could dump the result of sending a REPORT LUN to the device, that
> would be useful. You could use the sg interface on a system (modify one of
> the sg utils programs, like sg_inq.c) that found the LUNs OK, or hack the
> kernel to dump the REPORT LUN output, or get a trace.

I'll try to do that.

  OG.
