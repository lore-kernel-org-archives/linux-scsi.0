From: Andrew Vasquez <praka@san.rr.com>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b3).
Date: Fri, 6 Jun 2003 08:07:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606150729.GA10992@praka.local.home>
References: <20030530160040.GA11238@praka.local.home> <20030530235234.GA31401@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orngca-mls01.socal.rr.com ([66.75.160.16]:61645 "EHLO
	orngca-mls01.socal.rr.com") by vger.kernel.org with ESMTP
	id S261932AbTFFPtO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2003 11:49:14 -0400
Received: from san.rr.com (66-75-128-22.san.rr.com [66.75.128.22])
	by orngca-mls01.socal.rr.com (8.11.4/8.11.3) with ESMTP id h56G03M14158
	for <linux-scsi@vger.kernel.org>; Fri, 6 Jun 2003 09:00:03 -0700 (PDT)
Received: from san.rr.com (localhost [127.0.0.1])
	by san.rr.com (8.12.3/8.12.3/SuSE Linux 0.6) with ESMTP id h56F7Uvl011037
	for <linux-scsi@vger.kernel.org>; Fri, 6 Jun 2003 08:07:30 -0700
Received: (from praka@localhost)
	by san.rr.com (8.12.3/8.12.3/Submit) id h56F7TIB011036
	for linux-scsi@vger.kernel.org; Fri, 6 Jun 2003 08:07:29 -0700
Content-Disposition: inline
In-Reply-To: <20030530235234.GA31401@krispykreme>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Sat, 31 May 2003, Anton Blanchard wrote:

> > A new version of the 8.x series driver for Linux 2.5.x kernels has
> > been uploaded to SourceForge:
> > 
> > 	http://sourceforge.net/projects/linux-qla2xxx/
> 
> A few suggestions:
> 
> - Use pci_set_mwi since it will set the cacheline size if necessary.
> - Dont set/clear IO/MEMORY/MASTER, it should be handled in
>   pci_enable_device/pci_set_master.
> 

Thanks for the tips -- changes will be integrated into the next
release.

Regards,
Andrew Vasquez
