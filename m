From: "D.B. Sweeney" <for_unix@yahoo.com>
Subject: Problem in the (megaraid) raid/scsi subsystem leading to I/O Errors or Panic
Date: Thu, 7 Sep 2006 10:33:07 -0700 (PDT)
Message-ID: <20060907173307.92990.qmail@web58411.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web58411.mail.re3.yahoo.com ([68.142.236.179]:38827 "HELO
	web58411.mail.re3.yahoo.com") by vger.kernel.org with SMTP
	id S1751588AbWIGTFq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Sep 2006 15:05:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

Recently, I have been investigating an issue on a
multitude of machines using the Intel SRCZCRX raid
controller (LSI rebrand). The problem is that a number
of these machines lockup/hang with the following sort
of errors on the console:

megaraid: aborting-209373 cmd=2a <c=0 t=0 l=0>
megaraid: aborting-209372 cmd=2a <c=0 t=0 l=0>
megaraid: reset-209373 cmd=2a <c=0 t=0 l=0>
megaraid: 3 pending cmds; max wait 180 seconds
megaraid: pending 3; remaining 180 seconds
<COUNTDOWN CUT FOR BREVITY>
megaraid: pending 3; remaining 5 seconds
megaraid: critical hardware error!
megaraid: reset-209373 cmd=2a <c=0 t=0 l=0>
megaraid: hw error, cannot reset
megaraid: reset-209372 cmd=2a <c=0 t=0 l=0>
megaraid: hw error, cannot reset
megaraid: reset-209373 cmd=2a <c=0 t=0 l=0>
megaraid: hw error, cannot reset
megaraid: reset-209372 cmd=2a <c=0 t=0 l=0>
megaraid: hw error, cannot reset
scsi: device set offline - command error recover
failed: host 0 channel 
0 id 0 lun 0
 I/O error: dev 08:06, sector 1578120
SCSI disk error : host 0 channel 0 id 0 lun 0 return
code = 6000000
 I/O error: dev 08:05, sector 14728
SCSI disk error : host 0 channel 0 id 0 lun 0 return
code = 6000000
 I/O error: dev 08:06, sector 25016
 I/O error: dev 08:06, sector 25024
 I/O error: dev 08:06, sector 25032

In order to recover from this condition, the box must
be cycled. I have perused google and the contents of
this list but I cannot seem to find a solution or
explanation for what I am experiencing. I understand
the response of the SCSI subsystem to the megaraid
failure and I can control that from fstab, a bit.
However, I have not been able to recreate the failure
on demand (it occurs seemingly at random intervals),
find a good explanation of what's causing the failure,
or determine what else I can do to troubleshoot the
problem.

Additional information about the machines that are
experiencing this failure are:

        
************************************************
MEGARC MegaRAID Configuration 
Utility(LINUX)-1.11(12-07-2004)
By LSI Logic Corp.,USA
        
************************************************
Information of Adapter-0 (#Adapter(s) on system: 1)
        
************************************************
Firmware Version : 414C
BIOS Version : H429
Logical Drives : 01
DRAM : 128MB
Rebuild Rate : 30%
Flush Interval : 4 secs
Number Of Chnls : 2
Bios Status : Enabled
Alarm State : Enabled
Auto Rebuild : Enabled
FW : SPAN-8, 40-LD
BIOS Config AutoSelection : USER
BIOS Echos Mesg : ON
BIOS Stops On Error : ON
Initiator Id : 7(Clustered Firmware)
Board SN: 33686018
**********************************************************************

kernel: megaraid: v2.10.8.2 (Release Date: Mon Jul 26
12:15:51 EDT 2004)

I have running an SMP 2.4.18 Linux kernel.

If someone can point me in the right direction for
diagnosing this failure, I would appreciate it. I am
willing to supply more information if it will help. I
would much rather understand the cause of the failure
at this point, as oppossed to blindly upgrading raid
firmware/driver versions, to assure myself that the
problem is resolved (mostly because the failure is not
reproducible on demand).

Thanks in advance.

D.B.

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
