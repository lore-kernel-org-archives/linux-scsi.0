From: Linda Lee <lindaclee2002@yahoo.com>
Subject: SCSI reserve/release
Date: Thu, 27 Feb 2003 12:51:35 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030227205135.31139.qmail@web14612.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I'd like to simulate the SCSI-3 Persistent Group
Reservation of Solaris on Linux using Linux
reserve/release mechanism.  My understanding is that
to make reservation on the device on Linux, I can
issue ioctl() with SCSI_IOCTL_SEND_COMMAND along with
SCSI command "RESERVE" as part of the input data. It
is similar for the release mechanism.  Instead of
"RESERVE" command in the ioctl, put "RELEASE" instead.

Regarding the SCSI reset, I can issue ioctl() with
SG_SCSI_RESET.

Is my approach correct?  Does anyone had done this
before?

Thanks,

Linda

__________________________________________________
Do you Yahoo!?
Yahoo! Tax Center - forms, calculators, tips, more
http://taxes.yahoo.com/
