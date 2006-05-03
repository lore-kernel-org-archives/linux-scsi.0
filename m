From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 0/5] iscsi update
Date: Tue, 02 May 2006 19:46:34 -0500
Message-ID: <1146617194.2601.13.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60589 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S965056AbWECAoR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2006 20:44:17 -0400
Received: from [192.168.0.4] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k430iFWf010707
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 2 May 2006 19:44:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches fix some bugs in the last patchset that occur when
a login task gets stuck. It also fixes a performance problem that some
people have been hitting. And adds some callbacks for iser and offload.
The patches were made against scsi-misc.

