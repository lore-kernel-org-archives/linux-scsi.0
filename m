From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Problem : QLogic QLA104x PCI SCSI Adapter with HP CDWriter+ 9200
Date: Fri, 19 Apr 2002 18:36:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CC09BEF.3491B987@torque.net>
References: <20020419184727.A16159@yenveedu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Dionysius Wilson Almeida <dwilson@yenveedu.com>
Cc: linux-scsi@vger.kernel.org

Dionysius Wilson Almeida wrote:
> 
> Hi Everyone,
> 
> I'm using QLogic QLA104x PCI SCSI Adapter with HP CDWriter+ 9200.
> The QLogic BIOS version is 6.14, ISP Firmware 4.50.
> 
> During the bootup, I see :
> 
> scsi : aborting command due to timeout : pid 6, scsi0, channel 0, id 6, lun 0 0x12 00 00 00 ff 00
> 
> But eventually it recognizes the CD Writer and configures it.

This looks like a scsi bus termination problem.

It seems as though the QLogic controller is ultra wide (16 bit)
while the HP cdwriter is "scsi-2" (8 bit wide) and is the only
thing on the scsi bus. How are you terminating the scsi bus with 
this configuration?

Doug Gilbert
