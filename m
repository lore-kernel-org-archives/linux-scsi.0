From: michaelc@cs.wisc.edu
Subject: [PATCH 0/6] iscsi changes for scsi-misc
Date: Fri, 20 Dec 2013 12:53:41 -0600
Message-ID: <1387565627-5218-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33111 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab3LTSx7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Dec 2013 13:53:59 -0500
Received: from localhost.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id rBKIrs2W010889
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2013 12:53:58 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches are some features and fixes for scsi-misc.

James, if you were going to merge the libiscsi locking changes here
http://www.spinics.net/lists/linux-scsi/msg69903.html
do not bother. The qlogic patches that were just merged had a conflict.
The patches in the following emails should apply cleanly to misc.


