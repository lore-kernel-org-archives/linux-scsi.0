From: "Lee Xing" <lxing@Crossroads.com>
Subject: SCSI passthrough ioctl calls vs. sd/sg devices
Date: Wed, 21 Apr 2004 17:04:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FEFBE@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:40886 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S262208AbUDUWEJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 18:04:09 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I would appreciate it if some one could clarify this.  It's a bit confusing.

<<The Linux SCSI Generic (sg) HOWTO>> page 2 says "The sg driver permits user applications to send SCSI commands to devices that understand them.  SCSI commands are 6, 10, 12 or 16 bytes long.  The SCSI disk driver (sd), once device initialization is complete, only sends SCSI READ and WRITE commands."

<<The Linux 2.4 SCSI subsystem HOWTO>> page 3 says "Sg is a SCSI command pass through device that uses a char device interface.  General purpose Linux commands should not be used on sg devices."

My questions are:

- looks like SCSI passthrough ioctl calls can only apply 
  to sg devices.  Is it right, and can we apply SCSI
  passthrough ioctl calls to sd devices as well?
- what are the so-called "General purpose Linux commands"?
  Are they read()/write() or 'mount' / 'dd' or something else?

What should we do if we need to 'mount' a file system on a disk and also need to issue SCSI passthrough ioctl calls to the same disk?  Maybe we should use both sd and sg (i.e. mount the file system to /dev/sda, and issue SCSI passthrough ioctl calls to /dev/sg0 that maps to the same physical disk)?  'mount' doesn't work on sg devices as I was told earlier.

Many thanks,


Lee


