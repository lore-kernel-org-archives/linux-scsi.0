From: "Edwards, Scott (MED, Kelly IT Resouces)" <James.Edwards@med.ge.com>
Subject: RE: Help - looking for a Linux SCSI testing utility
Date: Tue, 25 May 2004 09:56:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1F6D1D1660975A4887628A011443A1BC0305E3C1@uswaumsx13medge.med.ge.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ext-ch1gw-5.online-age.net ([64.37.194.13]:23691 "EHLO
	ext-ch1gw-5.online-age.net") by vger.kernel.org with ESMTP
	id S264894AbUEYO4c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 May 2004 10:56:32 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Lee Xing' <lxing@Crossroads.com>, linux-scsi@vger.kernel.org


I have been trying to find a way to send a write cache command to a scsi
drive.  I found the sg_utils which I haven't gotten to send a write
cache command, but they might do what you want.

http://www.torque.net/sg

-Scott


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Lee Xing
Sent: Tuesday, May 25, 2004 8:43 AM
To: linux-scsi@vger.kernel.org
Subject: Help - looking for a Linux SCSI testing utility


Hi,

When we were working on Windows platform, we had a couple of tools that
can issue selected SCSI command(s) to selected device(s).  Is there a
similar tool for Linux?  It would be great if we can use it to send
different SCSI command(s) to selected sd/sg device(s).

Thanks,


Lee 


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
