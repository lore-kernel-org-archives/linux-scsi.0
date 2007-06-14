From: Parav Pandit <paravpandit@yahoo.com>
Subject: doubts about sg driver
Date: Thu, 14 Jun 2007 10:47:10 -0700 (PDT)
Message-ID: <84219.67525.qm@web30104.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web30104.mail.mud.yahoo.com ([209.191.69.36]:30112 "HELO
	web30104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751102AbXFNRrM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jun 2007 13:47:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Few basic questions on sg driver:

1. Are there any hooks that low level HBA driver needs
to implement - for providing support for SG (SCSI
generic) driver?
Or SG always interacts with scsi_mod and it is
transparent to the HBA drivers?
>From the tldp How-to and sg.c it looks like it doesn't
directly talk with Low level HBA driver, but want to
confirm.

2. Can applications talk with SCSI RAID controller
device (some targets exposes LUN-0 as controller) 
through sg interface or it is only for storage
devices?

3. How is the mapping between /dev/sda /dev/sdb etc to
/dev/sg0 /dev/sg1 etc?
Is this information is accessible via procfs or sysfs
interface?

Regards,
Parav Pandit



       
____________________________________________________________________________________
Be a better Globetrotter. Get better travel answers from someone who knows. Yahoo! Answers - Check it out.
http://answers.yahoo.com/dir/?link=list&sid=396545469
