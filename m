From: Josip Rodin <joy@entuzijast.net>
Subject: Re: kernel 2.6.26.3 qla2xxx oopsing on Fire 280R
Date: Tue, 9 Sep 2008 16:39:32 +0200
Message-ID: <20080909143932.GA27117@orion.carnet.hr>
References: <20080904093929.GA29006@orion.carnet.hr> <20080908211331.GC22598@plap4-2.qlogic.org> <20080909015321.GA14147@orion.carnet.hr> <20080909020102.GE25591@plap4-2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orion.CARNet.hr ([161.53.160.90]:47798 "EHLO orion.carnet.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221AbYIIOjf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Sep 2008 10:39:35 -0400
Content-Disposition: inline
In-Reply-To: <20080909020102.GE25591@plap4-2.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Sep 08, 2008 at 07:01:02PM -0700, Andrew Vasquez wrote:
> Yes, please do try the patch.  Could you also enable error-logging via
> the ql2xextended_error_logging module parameter:
> 
> 	# insmod qla2xxx.ko ql2xextended_error_logging=1
> 
> And send the kernel messages...  Thanks, AV

OK, I reset the bisection, pulled the latest updates, applied your patch
and added the parameter to the initrd module setup, rebuilt after an
all-enter make oldconfig. After rebooting, it failed to load the firmware:

scsi(0): **** Load RISC code **** 
firmware: requesting ql2200_fw.bin 
scsi(0): Failed to load firmware image (ql2200_fw.bin). 
qla2xxx 0001:00:04.0: Firmware image unavailable. 

After the reboot, I noticed that I managed to screw up my silo setup,
so it's going to take me a wee bit more to recover. :<

-- 
     2. That which causes joy or happiness.
