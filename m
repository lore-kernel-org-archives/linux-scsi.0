From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: [bug]
Date: Thu, 4 Mar 2004 21:54:31 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040305055431.GB9315@praka.local.home>
References: <40426118.6000904@free.fr> <1078181191.1804.82.camel@mulgrave> <4043C172.1060800@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:59839 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S262221AbUCEGPS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2004 01:15:18 -0500
Content-Disposition: inline
In-Reply-To: <4043C172.1060800@free.fr>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: christophe varoqui <christophe.varoqui@free.fr>, Andrew Vasquez <andrew.vasquez@qlogic.com>

On Tue, 02 Mar 2004, christophe varoqui wrote:
> mm, digging this, I traced the bug to an sg_inq in my userspace code :
> do_inq(fd, 0, 1, 0x83, buff, 64, 1);
> 
> seting the size of the buff to a higher value (#define MX_ALLOC_LEN 255) 
> mutes the oops. Dunno what happened, it worked with size = 64 until 
> recently.
> 
> For completeness, the bug triggered at modprobe qla2200 because my code 
> got exec'ed by scsi hotplug events.
> 

Have you had any luck isolating the problem? I'd just like to know if
I need to peek any further into troubleshooting this as a qla2x00
problem.  

Thanks,
Andrew Vasquez
