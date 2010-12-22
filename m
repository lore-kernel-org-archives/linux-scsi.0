From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/3] Move SCST sysfs documentation to Documentation/ABI
Date: Wed, 22 Dec 2010 21:44:47 +0100
Message-ID: <201012222144.47522.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:59129 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab0LVUo5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Dec 2010 15:44:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, vst@vlnb.net, realrichardsharpe@gmail.com
Cc: scst-devel@lists.sourceforge.net, Greg Kroah-Hartman <gregkh@suse.de>

Since documentation of sysfs attributes must reside in Documentation/ABI, this
series of three patches moves the documentation of the SCST sysfs attributes
to that location. Please review.
