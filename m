From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [BUG] modprobe qla2300 doesn't complete
Date: Mon, 27 Dec 2004 11:59:43 -0700
Message-ID: <20041227185943.GA15759@colo.lackof.org>
References: <20040305041850.GA9124@colo.lackof.org> <20040305071721.GA9684@praka.local.home> <20040305172147.GB17305@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:31132 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S261948AbUL0S7w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Dec 2004 13:59:52 -0500
Content-Disposition: inline
In-Reply-To: <20040305172147.GB17305@colo.lackof.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org

On Fri, Mar 05, 2004 at 10:21:47AM -0700, Grant Grundler wrote:
...
> appended. I've trimmed it down...full log is at:
> ftp://gsyprf10.external.hp.com/kernels/rx2600/gsyprf3.log_qla2300_F_Port
> 
> BTW, this is running on an HP rx2600 (ia64) and both qla2312 ports
> are connected to one HP FC16 (IIRC) switch. Three DS2405 disk enclosures
> are also connected to the switch.  IIRC, only two are powered up.

Andrew,
I finally got this config working. I changed the FC16 port settings from
"fabric" to "loop" mode for the three DS2405 disk trays.

To make things simple, I've set half the ports to loop mode and the
other half to fabric mode. Hosts plug into "fabric" ports and disks
into "loop" ports.

I'm over simplifying things here since I got this working a month
or two ago. If someone wants to poke around with this config,
please ask.

thanks,
grant
