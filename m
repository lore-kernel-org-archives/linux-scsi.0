From: =?iso-8859-1?q?Chris=20Rankin?= <rankincj@yahoo.com>
Subject: Incorrect module reference count in Linux 2.6.3
Date: Sun, 29 Feb 2004 12:25:43 +0000 (GMT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040229122543.86816.qmail@web40605.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web40605.mail.yahoo.com ([66.218.78.142]:27419 "HELO
	web40605.mail.yahoo.com") by vger.kernel.org with SMTP
	id S262039AbUB2MZo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 07:25:44 -0500
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org

Hi,

After using my FireWire scanner in Linux 2.6.3, I saw
that the SBP2 low-level SCSI driver could no longer be
removed:

sg                     35216  0 
sbp2                   25344  4294967295 
scsi_mod              111900  2 sg,sbp2

Could the sg.ko module be issuing more
scsi_device_put() calls than scsi_device_get() calls?
Or confusing the low-level driver's reference count
through some other means? I am assuming that
"4294967295" is really "-1".

Cheers,
Chris



	
	
		
___________________________________________________________
Yahoo! Messenger - Communicate instantly..."Ping" 
your friends today! Download Messenger Now 
http://uk.messenger.yahoo.com/download/index.html
