From: "Lee Xing" <lxing@Crossroads.com>
Subject: Help - how to identify the callers in a SCSI lower-level driver
Date: Wed, 7 Apr 2004 14:52:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FEF9F@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 65-68-235-6.ded.swbell.net ([65.68.235.6]:58542 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S264180AbUDGTwH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Apr 2004 15:52:07 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm writing a pseudo Linux lower-level SCSI driver, which interfaces with the standard mid-level driver and needs to identify different calling applications in Linux user space.  For example, there are 2 applications, app1 and app2, in user space, and they both use /dev/hda.  We don't need the SCSI lower-level driver to know the applications' names "app1" or "app2", but just need it to tell the (SCSI passthrough ioctl) calls are from the "this" application or from "that" application.

I'm not sure if this is doable in Linux SCSI lower-level driver, but any suggestions and/or hints would be highly appreciated.

Many thanks,


Lee

