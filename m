From: =?iso-8859-1?q?Liong=20Hoong?= <liongshliongsh@yahoo.com>
Subject: sg_io_hrd_t - host_status error (0x05)
Date: Fri, 23 Apr 2004 11:11:08 +0800 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040423031108.68982.qmail@web40001.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web40001.mail.yahoo.com ([66.218.78.19]:8082 "HELO
	web40001.mail.yahoo.com") by vger.kernel.org with SMTP
	id S264667AbUDWDL2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 23:11:28 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I have set up the main control structure for the
version 3 SCSI generic driver. I am trying to send
down some opcodes (vendor specific) to a usb mass
storage device. Found that I encountered host_status
error, SG_ERR_DID_ABORT whenever I send opcodes from
0x80 to 0x9f, but encountered no errors with other
opcodes. 

The errors occured even without the device plugged in,
which seem the sg driver has exclusively blocked the
opcodes from 0x80 to 0x9f. Is it true?? Is there any
work around for this??

Is it because of Group 4 (0x80 to 0x9f) need 16 bytes
of cdb length? But even I prepare the cdb of 16 bytes,
it also failed. 

I am using red hat 8.0, 2.4.18. 

Thanks for any helps and comments!
Sean

__________________________________________________
Do You Yahoo!?
Log on to Messenger with your mobile phone!
http://sg.messenger.yahoo.com
