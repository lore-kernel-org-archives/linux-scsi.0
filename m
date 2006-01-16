From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Qlogic 2460 Query
Date: Mon, 16 Jan 2006 13:17:24 -0800
Message-ID: <20060116211724.GB13315@andrew-vasquezs-powerbook-g4-15.local>
References: <Pine.LNX.4.58.0601101930080.27390@moon.cmie.ernet.in> <20060114013640.GE7411@andrew-vasquezs-powerbook-g4-15.local> <Pine.LNX.4.58.0601141836580.23973@moon.cmie.ernet.in> <20060114143236.GD13373@andrew-vasquezs-powerbook-g4-15.local> <Pine.LNX.4.58.0601142110590.28904@moon.cmie.ernet.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:13558 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1751210AbWAPVR0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2006 16:17:26 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0601142110590.28904@moon.cmie.ernet.in>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nohez <nohez@cmie.com>
Cc: linux-scsi@vger.kernel.org

On Sat, 14 Jan 2006, Nohez wrote:

> I have attached config file. How can I find out the driver variant that
> OpenSuSE is using ? I have attached modinfo output. Will this help ?

Ok, I was able to get a machine running with these sources and
duplicate the problem.  Seems the sources are missing the following
patch:

http://marc.theaimsgroup.com/?l=linux-scsi&m=113720091219427&q=raw

Try that out and let me know if it solves the problem.

Thanks,
AV
