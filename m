From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [BUG] modprobe qla2300 doesn't complete
Date: Fri, 5 Mar 2004 08:57:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040305155717.GA17305@colo.lackof.org>
References: <20040305041850.GA9124@colo.lackof.org> <20040305071721.GA9684@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:41627 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S262630AbUCEP5U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2004 10:57:20 -0500
Content-Disposition: inline
In-Reply-To: <20040305071721.GA9684@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>, linux-scsi@vger.kernel.org, Grant Grundler <grundler@parisc-linux.org>

On Thu, Mar 04, 2004 at 11:17:21PM -0800, Andrew Vasquez wrote:
> I've seen this behaviour before, I thought we fixed this :(

oh - bummer. :^(

> > I can make the system remotely available if someone wants to
> > debug this some more.
> 
> That may be useful.

Yes. :^)
(I've debugged a fair number of issues like this in the past)

Andrew, I need preferred login, public ssh key (eg id_rsa.pub),
and telephone number where I reach in case of urgent admin issues.
I can then setup an account and explain how to access.

>   In the interim, could you just enable a couple of
> debug settings in the driver and rerun against the volitile fabric

yes - np.

> (just a short period, say 30 seconds), then send the /var/log/messages
> file.  I believe I know the problem, I just need to be sure the
> stimulus coming from the fabric is what I would expect.
> 
> 	o Set DEBUG_QLA2100 to 1 in qla_settings.h
> 
> 	o Define QL_DEBUG_LEVEL_2 in qla_dbg.h.

I'll include output in my next reply.

thanks,
grant

> 
> Regards,
> Andrew Vasquez
> QLogic Corporation
