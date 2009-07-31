From: david@lang.hm
Subject: bad performance on 3 of 20 boxes with 3ware card
Date: Fri, 31 Jul 2009 15:02:37 -0700 (PDT)
Message-ID: <alpine.DEB.1.10.0907311459220.28013@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:59264 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbZGaWCk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2009 18:02:40 -0400
Received: from asgard.lang.hm (asgard.lang.hm [10.0.0.100])
	by bifrost.lang.hm (8.13.4/8.13.4/Debian-3) with ESMTP id n6VM2biQ004791
	for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2009 15:02:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I hae 20 identical boxes (2x 4-core cpus, 64G ram, 16x1TB SATA drives on 
07:00.0 RAID bus controller: 3ware Inc 9650SE SATA-II RAID (rev 01) raid 
6) running linux 2.6.30

on 3 of the 20 I seem to have a max write speed of ~5MB/sec (as opposed to 
>100 MB/sec)

any pointers on how I can identify what is different about these three 
boxes?

David Lang

