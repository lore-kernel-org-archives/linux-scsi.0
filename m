From: Russell Lewis <spamhole-2001-07-16@deming-os.org>
Subject: Looking for Docs: how to queue SCSI commands from within the kernel
Date: Wed, 31 Jul 2002 13:06:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D484341.20203@deming-os.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from deming-os.org (bi01p1.co.us.ibm.com [32.97.110.142])
	by deming-os.org (8.11.6/8.11.6) with ESMTP id g6VKSkW24040
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jul 2002 13:28:46 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am developing a SCSI low-level driver that does some virtualization 
and then needs to queue up commands to other, "real" SCSI devices.  I 
presume that I will be queuing up commands to the mid-layer, just like 
the other high-level drivers do.  Where can I read about how to do this?

Thanks in advance,
    Russ Lewis

