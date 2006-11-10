From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 2/2] libsas fails to compile on s390
Date: Fri, 10 Nov 2006 08:50:50 +0100
Message-ID: <20061110075050.GD7129@osiris.boeblingen.de.ibm.com>
References: <200611090357.kA93vA1u004099@shell0.pdx.osdl.net> <20061109003407.f2c5ea5b.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:24857 "EHLO
	mtagate4.uk.ibm.com") by vger.kernel.org with ESMTP
	id S1946017AbWKJHvn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Nov 2006 02:51:43 -0500
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate4.uk.ibm.com (8.13.8/8.13.8) with ESMTP id kAA7pgP7166420
	for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2006 07:51:42 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kAA7sQsg2429000
	for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2006 07:54:26 GMT
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kAA7pfQF005457
	for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2006 07:51:41 GMT
Content-Disposition: inline
In-Reply-To: <20061109003407.f2c5ea5b.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, schwidefsky@de.ibm.com

On Thu, Nov 09, 2006 at 12:34:07AM -0800, Andrew Morton wrote:
> > Explicitly include scatterlist.h in sas_internal.h to avoid the implicit
> > include dependency via the pci.h header.  For s390 the scatterlist.h header
> > is not included because CONFIG_PCI=n.
> err, please ignore this one....
> [...]
> distcc[16143] ERROR: compile drivers/scsi/libsas/sas_phy.c on bix/32 failed
> make[1]: *** [drivers/scsi/libsas/sas_phy.o] Error 1
> make: *** [drivers/scsi/libsas/sas_phy.o] Error 2

Strange... compiles fine for me. But maybe we should simply merge this one
instead?

http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.19-rc5/2.6.19-rc5-mm1/broken-out/git-sas-kconfig-fix.patch
