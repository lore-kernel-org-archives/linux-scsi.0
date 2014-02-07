From: michaelc@cs.wisc.edu
Subject: [PATCH 0/6]: iscsi changes for scsi-misc (v2)
Date: Fri,  7 Feb 2014 00:41:36 -0600
Message-ID: <1391755302-57206-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40274 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbaBGGl4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Feb 2014 01:41:56 -0500
Received: from localhost.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id s176fqtW015126
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 7 Feb 2014 00:41:55 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patchset has Mellanox's libiscsi locking changes, and various
fixes.

V2 - Fix for MaxCmdSn handling in patch 3/6 where the part of the function
that also updates the MaxCmdSn also got cut by accident.

