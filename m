From: "Edwards, Scott (MED, Kelly IT Resouces)" <James.Edwards@med.ge.com>
Subject: RE: Help - looking for a Linux SCSI testing utility
Date: Sun, 30 May 2004 17:24:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1F6D1D1660975A4887628A011443A1BC0305E3DD@uswaumsx13medge.med.ge.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ext-ch1gw-3.online-age.net ([216.34.191.37]:14040 "EHLO
	ext-ch1gw-3.online-age.net") by vger.kernel.org with ESMTP
	id S264424AbUE3WY6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 May 2004 18:24:58 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Matthew Wilcox' <willy@debian.org>
Cc: 'Erik Mouw' <erik@harddisk-recovery.com>, linux-scsi@vger.kernel.org



On Thursday, May 27, 2004 at 8:54 PM, Matthew Wilcox wrote:

> Are you using libata or the older IDE drivers?

It's using libata and the ata_piix driver.

I also confirmed with the drive rep. that the Mode Page method of
controlling the write cache will not work on a Serial ATA drive.

Thanks
  -Scott


