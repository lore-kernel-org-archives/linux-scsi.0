From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600 aacraid PERC
 3/Di Container goes offline
Date: Thu, 28 Oct 2004 00:53:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041028005302.753a2d52.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:28872 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262813AbUJ1HzC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2004 03:55:02 -0400
Received: from bix (build.pdx.osdl.net [172.20.1.2])
	by mail.osdl.org (8.11.6/8.11.6) with SMTP id i9S7t1912981
	for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2004 00:55:01 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



Begin forwarded message:

Date: Thu, 28 Oct 2004 00:50:31 -0700
From: bugme-daemon@osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 3651] New: dell poweredge 4600 aacraid PERC 3/Di Container goes offline


http://bugme.osdl.org/show_bug.cgi?id=3651

           Summary: dell poweredge 4600 aacraid PERC 3/Di Container goes
                    offline
    Kernel Version: 2.6.10-rc1, 2.6.9, 2.6.8, 2.6.7, 2.6.6
            Status: NEW
          Severity: high
             Owner: andmike@us.ibm.com
         Submitter: oliver.polterauer@ewave.at
                CC: oliver.polterauer@ewave.at


Distribution: Debian Sarge
Hardware Environment: Dell Poweredge 4600, 5 Disks each 146GB in a Raid 5 in 
one container, 8 GB RAM, Dual Xenon 2GHz. The Perc 3/Di Controller is on 
Firmware version 2.80 Build 6092
Software Environment: aacraid
Problem Description: 
The Container on the PERC 3/Di Controller goes offline on heavy I/O Load with 
the following error message:

SCSI:0 (0:0): rejecting I/O to offline device
Buffer I/O error due to I/O error on sda8

Steps to reproduce:

I am using bonnie++ to produce I/O load on the only Volume on the Perc 3/Di 
Controller with the following parameters bonnie++ -d /var/lib/postgres/test -s 
16000 -n 150 -r 8000 -u nobody:nogroup

my partition table:

/dev/sda1 --> /boot (80mb)
/dev/sda2 --> swap (16 GB)
/dev/sda3 --> /root (4 GB)
/dev/sda5 --> /home (4 GB)
/dev/sda6 --> /tmp (1 GB)
/dev/sda7 --> /var (8 GB)
/dev/sda8 --> /var/lib/postgres (502 GB)

Filesystem ext3
kernel is a non modular plain vanilla kernel source (no patches)

I have turned on remote syslog to our syslog server, but it did not log any 
more errormessages as stated above. The error messages above are printed only 
on the console


Best regards,

Oliver

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
