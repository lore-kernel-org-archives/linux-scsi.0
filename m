From: "Bryan Henderson" <hbryan@us.ibm.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Tue, 9 Apr 2002 18:40:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFA153CF94.43AA0621-ON87256B97.0008C068@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Rick Stevens <rstevens@vitalstream.com>
Cc: linux-scsi@vger.kernel.org

>E.g. "/dev/dsk/c0t1d2s3" is controller 0 (first SCSI controller seen on
>the bus), target ID 1, LUN 2, partition (slice) 3.  Simple, unambiguous
>and repeatable.

For many purposes, you're right, and for that reason devfs already does 
this.  However, in some cases these are not repeatable.  A volume that is 
LUN 5 today could be LUN 7 tomorrow.  This is true in heavy-duty disk 
storage subsystems that let you create and destroy logical units on the 
fly, using the physical medium as a resource pool.  And what is LUN 5 for 
me could be LUN 7 for you at the same time, if we're both wired into the 
same storage subsystem.

