From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: [BUG] modprobe qla2300 doesn't complete
Date: Thu, 4 Mar 2004 23:17:21 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040305071721.GA9684@praka.local.home>
References: <20040305041850.GA9124@colo.lackof.org>
Reply-To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:57330 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S261998AbUCEHiE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Mar 2004 02:38:04 -0500
Content-Disposition: inline
In-Reply-To: <20040305041850.GA9124@colo.lackof.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Grant Grundler <grundler@parisc-linux.org>

On Thu, 04 Mar 2004, Grant Grundler wrote:

> qla2300 driver in 2.6.4-rc1 is showing a robustness problem.
> When modprobe'ing the driver, it never completes initialization.
> It continually prints the "Topology - (F_Port), Host Loop address 0xffff"
> messages.
>

I've seen this behaviour before, I thought we fixed this :(

> I know I have a bad disk or something connected to
> the FC switch. And when I power off one of the disk arrays
> (no raid controllers, just JBOD) the problem goes away...but I
> expect better behavior from qla2300 driver.
> 

Yes, me too...

> I can make the system remotely available if someone wants to
> debug this some more.
> 

That may be useful.  In the interim, could you just enable a couple of
debug settings in the driver and rerun against the volitile fabric
(just a short period, say 30 seconds), then send the /var/log/messages
file.  I believe I know the problem, I just need to be sure the
stimulus coming from the fabric is what I would expect.

	o Set DEBUG_QLA2100 to 1 in qla_settings.h

	o Define QL_DEBUG_LEVEL_2 in qla_dbg.h.

Regards,
Andrew Vasquez
QLogic Corporation
