From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b9).
Date: Wed, 14 Jan 2004 14:55:54 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060EDDD@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from enigma.qlogic.com ([198.70.193.17]:46582 "EHLO enigma.qlc.com")
	by vger.kernel.org with ESMTP id S264522AbUANWzk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2004 17:55:40 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>

All,

A new version of the 8.x series driver for Linux 2.6.x kernels has
been uploaded to SourceForge:

	http://sourceforge.net/projects/linux-qla2xxx/

Changes from previous release (8.00.00b8) include:

	o Merge several patches from Christoph Hellwig:
	  - IOCTL code optional and split from main code.
	  - Simplify wait routines used for MBX commands and IOCTLS.
	o Add full support for three new ISP chips - ISP2322, ISP6312,
	  and ISP6322.
	  - The increased size of the distribution tarball is a result
	    of the three new firmwares needed to support the chips.

Review the revision notes for further details of the changes in
8.00.00b9.

Regards,
Andrew Vasquez
QLogic Corporation
