From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Need to create sub-directories in /sys/class/fc_host/hostX/ directory
Date: Sat, 4 Apr 2009 01:26:35 -0700
Message-ID: <D7953566-5352-4719-A5B0-A2C82786119B@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:10093 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbZDDI0i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Apr 2009 04:26:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> 	I need to create two sub-directory in /sys/class/fc_host/hostX/
> directory. The directories are /sys/class/fc_host/hostX/fcoe for
> FCoE host attributes and /sys/class/fc_host/hostX/fcoe/statistics
> for FCoE statistics. I read the kernel documents regarding the
> kobject.txt as well as sample driver sources (kobject_example.c and
> kset_example.c) but could not find proper way to do this.
>
> 	The FC transport layer uses host_attributes transport container
> present in scsi_transport_template to display the FC host attributes
> and statistics. The transport container has only one attribute_group
> defined. So looks like I can add only one attribute group. The
> alternative is to create a new kobject and create a sysfs group.
> In order to do this I need to know the kobject of the parent
> directory(i.e /sys/class/fc_host/hostX). Since the hostX directory
> keeps changing as and when the driver gets unloaded and loaded, I
> can't use static implementation. Is there a way to know the parent
> directory for this particular directory. If not what is the best way
> to do this. Any help is highly appreciated.

Thanks,
Giridhar Malavali
