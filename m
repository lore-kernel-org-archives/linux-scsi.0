From: "Lee Xing" <lxing@Crossroads.com>
Subject: A question on low-level driver document
Date: Thu, 13 May 2004 18:47:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FEFF1@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:42297 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S264505AbUEMXrJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 19:47:09 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I could find <<SCSI mid_level - lower_lever driver interface>> for Linux kernel 2.6.  Is there a similar document for Linux 2.4?  The interface between mid_level and lower_level has quite a few changes from lk 2.4 to 2.6.

I'm trying to find the call stack after a low-level driver is loaded.  For example, after low-level driver calls scsi_register(), what's next, and how SCSI disks are registered with mid-level.

Thanks,


Lee

