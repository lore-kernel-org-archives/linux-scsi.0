From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b5).
Date: Thu, 31 Jul 2003 15:50:56 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060EC99@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
content-class: urn:content-classes:message
To: Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

All,

A new version of the 8.x series driver for Linux 2.6.x kernels has
been uploaded to SourceForge:

	http://sourceforge.net/projects/linux-qla2xxx/

This beta addresses several scanning issues reported against 
8.00.00b4:

	o Mid-layer will not scan storage with sparse luns and/or
	  no lun 0.

Review the revision notes for further details of the changes 
in 8.00.00b5.

Regards,
Andrew Vasquez
