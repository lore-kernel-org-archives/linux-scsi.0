From: Torrey Hoffman <torrey@lockdownnetworks.com>
Subject: aacraid, dbus, and RAID health status
Date: Tue, 16 Aug 2005 09:18:21 -0700
Message-ID: <1124209101.29691.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from red.lockdownnetworks.com ([67.105.193.226]:14304 "EHLO
	mx1.lockdownnetworks.com") by vger.kernel.org with ESMTP
	id S1030219AbVHPQYV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Aug 2005 12:24:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi.

I'm interested in setting up a system which can monitor the status of an
aacraid-based RAID system, ideally via dbus.

I've seen solutions on the web that poll the system using the 'afacli'
command line tool, and parse the output.  This seems less than optimal.

I want a system which doesn't use polling.  Surely it's possible to have
the kernel send out notifications if the health status of the RAID
changes?

Ideally these would be available via HAL (hald) and sent to user space
via dbus.  

I'm willing to patch the kernel and hald if required.  If no such
solution exists, I may be able to spend some paid work time writing it.
If I did, would there be some chance of getting it into the official
driver?  Would other people find this useful? 

I've been grepping the sources of .../drivers/scsi/... looking for
examples of kernel events or hotplug being used to notify user space of
changes in the RAID array health, without any luck.  Does any other
driver, (or the software RAID system) do anything like this? 

Thanks in advance for any tips or pointers. 

Please reply directly, as I'm not currently subscribed to linux-scsi. If
I get multiple off-list messages, I'll write and post a summary. 

Torrey Hoffman
torrey@lockdownnetworks.com
thoffman@arnor.net


