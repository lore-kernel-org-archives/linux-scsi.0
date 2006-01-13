From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 0/10] iscsi update
Date: Thu, 12 Jan 2006 23:00:38 -0600
Message-ID: <1137128438.9508.15.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60591 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S964890AbWAMFAq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 00:00:46 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id k0D50im0016387
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2006 23:00:45 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am again the iscsi monkey. The patchset was made against scsi-misc and
fixes xfs and jfs support, xfs or st or sg with 4k stacks, highmem
support, reworks the transport class to allow HW iscsi to hook in and
fixes several refcount bugs.

