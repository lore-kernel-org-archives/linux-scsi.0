From: Steven Dake <sdake@mvista.com>
Subject: Re: SCSI won't compile with PROC enabled on 2.6.0-test5
Date: Wed, 24 Sep 2003 12:17:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064431028.13033.324.camel@persist.az.mvista.com>
References: <1064429833.13033.316.camel@persist.az.mvista.com>
	 <20030924200954.A23837@infradead.org>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rav-az.mvista.com ([65.200.49.157]:47170 "EHLO
	zipcode.az.mvista.com") by vger.kernel.org with ESMTP
	id S261621AbTIXTRO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 15:17:14 -0400
In-Reply-To: <20030924200954.A23837@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org


On Wed, 2003-09-24 at 12:09, Christoph Hellwig wrote:
> On Wed, Sep 24, 2003 at 11:57:13AM -0700, Steven Dake wrote:
> > The compile result is:
> 
> That looks very strange..  I don't have plain 2.6.0-test5 around
> here, but current BK compiles fine.  Not that I disabled procfs
> previously :)
> 
> Can you reproduce this with a stock current tree or latest -bk
> snapshot?
> 
> 
Christoph

I produced with vanilla kernel.org 2.6.0-test5 with no changes.  If I
turn off proc, the compile works fine (not surprising..).  Toolchain is

[sdake@persist md]$ gcc --version
gcc (GCC) 3.2.2 20030222 (Red Hat Linux 3.2.2-5)

Perhaps it is my config file.  I started with a 2.4 kernel config,
copied it into 2.6, make menuconfig, then went with it.  I know this
process worked in previous versions of the 2.5/2.6 kernel tree with SCSI
and proc enabled so it might work now...

I'll try a clean config and try to reproduce to remove the possibility
that the 2.4 config is causing the problem.  I'll post back results when
done.

Thanks
-steve


