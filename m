From: Russell Lewis <spamhole-2001-07-16@deming-os.org>
Subject: Looking for info: Initiating a SCSI command from inside the kernel
Date: Tue, 06 Aug 2002 11:07:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D501074.2090802@deming-os.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from deming-os.org (bi01p1.co.us.ibm.com [32.97.110.142])
	by deming-os.org (8.11.6/8.11.6) with ESMTP id g76IVdW22099
	for <linux-scsi@vger.kernel.org>; Tue, 6 Aug 2002 11:31:39 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm writing a SCSI driver for Linux that does some virtualization.  From 
inside the kernel, I need to be able to queue up SCSI commands on other 
SCSI devices.  Is there a website where I can read up on the appropriate 
calls to do this?

Thanks,
    Russ Lewis

