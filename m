From: Subrahmanya Sastry K V <skotra@npd.hcltech.com>
Subject: Question on SMP
Date: Thu, 11 Jul 2002 15:06:38 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D2D51A6.6461FD4C@npd.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, ilugc@aero.iitm.ernet.in

Hi,

I would like to run my iSCSI pseudo-HBA driver program on a
SMP machine. But my driver doesn't support SMP. Is there any
way by which I can disable all the processors but one in the
SMP machine dynamically and run my program, as if it is running
on a UP machine?

( Statically disabling the SMP support in the kernel config file
   and recompiling the kernel is one way. Any clues on
    how to achieve it dynamically?)

Regards,
Sastry

--
Subrahmanya Sastry K V
HCL Tech, Vadapalani, Chennai-26
Ph: +91-44-3728366  Xtn-1146
http://san.hcltech.com


