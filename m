From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sg_io_hrd_t - host_status error (0x05)
Date: Sat, 01 May 2004 11:53:56 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40930334.4040908@torque.net>
References: <20040430071234.67120.qmail@web40005.mail.yahoo.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:16656 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261416AbUEBEiU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 May 2004 00:38:20 -0400
In-Reply-To: <20040430071234.67120.qmail@web40005.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Liong Hoong <liongshliongsh@yahoo.com>
Cc: linux-scsi@vger.kernel.org

Liong Hoong wrote:
> Hi,
> 
> Sorry if there is any misunderstanding in my previous
> questions.
> I would like to ask, 
> I am using Linux Red Hat 8.0, kernel 2.4.18. I used
> the SG driver version 3 without any modification of
> the kernel. I encountered host_status error (0x05)
> ONLY on sending opcodes from 0x80 to 0x9f. Can anyone
> give me hints on why or which part of the kernel codes
> that might failed this specific range of opcodes? Or
> is there any work around or patches? Anyone out there
> did experience similar problems and like to share with
> me?

Sean,
I assume that you have already determined (via another OS)
that the device really does accept 16 byte SCSI commands
in that opcode range.

As mentioned in my previous post the 12 to 16 byte cdb
expansion occurred in lk 2.4.15. Maybe the usb-storage driver
took a few versions to catch up. Apart from vendor specific
commands, there would not be a lot of demand for the
usb-storage driver to support 16 byte commands.
Perhaps you should try a more recent version of the linux
kernel. If the problem persists then you are more likely to
get help.

Doug Gilbert


