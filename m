From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [BUG] modprobe qla2300 doesn't complete
Date: Fri, 12 Mar 2004 11:32:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040312183254.GC5446@colo.lackof.org>
References: <20040305041850.GA9124@colo.lackof.org> <20040305071721.GA9684@praka.local.home> <20040305172147.GB17305@colo.lackof.org> <20040309164033.GA21648@praka.local.home> <20040310221241.GA7903@colo.lackof.org> <20040312061119.GA6402@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:57489 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S262392AbUCLSc7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2004 13:32:59 -0500
Content-Disposition: inline
In-Reply-To: <20040312061119.GA6402@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>, Grant Grundler <grundler@parisc-linux.org>, linux-scsi@vger.kernel.org

On Thu, Mar 11, 2004 at 10:11:19PM -0800, Andrew Vasquez wrote:
> Sorry about leaving your machine in such a borked state, but, could
> you reverify the test?

Certainly.

>   I don't believe we'll need any extended error
> logging, so disable DEBUG2.

ok - I'll disable DEBUG2 and upgrade to 2.6.4-* kernel.

thanks,
grant
