From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 2/2] libsas fails to compile on s390
Date: Fri, 10 Nov 2006 10:00:44 +0100
Message-ID: <20061110090044.GE7129@osiris.boeblingen.de.ibm.com>
References: <200611090357.kA93vA1u004099@shell0.pdx.osdl.net> <20061109003407.f2c5ea5b.akpm@osdl.org> <20061110075050.GD7129@osiris.boeblingen.de.ibm.com> <20061110003908.ac98ee66.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:35669 "EHLO
	mtagate5.uk.ibm.com") by vger.kernel.org with ESMTP
	id S1946060AbWKJJBf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Nov 2006 04:01:35 -0500
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate5.uk.ibm.com (8.13.8/8.13.8) with ESMTP id kAA91YQW080974
	for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2006 09:01:34 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kAA94ILW2429122
	for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2006 09:04:18 GMT
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kAA91Xtr015448
	for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2006 09:01:34 GMT
Content-Disposition: inline
In-Reply-To: <20061110003908.ac98ee66.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, schwidefsky@de.ibm.com

On Fri, Nov 10, 2006 at 12:39:08AM -0800, Andrew Morton wrote:
> > But maybe we should simply merge this one
> > instead?
> > 
> > http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.19-rc5/2.6.19-rc5-mm1/broken-out/git-sas-kconfig-fix.patch
> 
> The original failure which we're tryimg to fix here occurred with that
> patch applied.
> 
> Oh well.

How that? s390 doesn't have CONFIG_ATA... This compile error only happens on
2.6.19-rc5 but not your -mm tree. That's why I thought the above mentioned
patch should fix this.
Maybe SCSI_SAS_LIBSAS should depend on SCSI && ATA && PCI?
