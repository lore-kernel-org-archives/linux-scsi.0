From: Dionysius Wilson Almeida <dwilson@yenveedu.com>
Subject: Re: Problem : QLogic QLA104x PCI SCSI Adapter with HP CDWriter+ 9200
Date: Tue, 23 Apr 2002 11:02:12 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020423110212.A24069@yenveedu.com>
References: <20020419184727.A16159@yenveedu.com> <3CC09BEF.3491B987@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3CC09BEF.3491B987@torque.net>; from dougg@torque.net on Fri, Apr 19, 2002 at 06:36:31PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

Hi,

The timeout problem is resolved by using safe option under host adapter
settings.  But still i'm unable to mount any CD on this drive even though it
plays normal audio CDs fine and also writes CDs properly.

-Wilson
* Douglas Gilbert (dougg@torque.net) wrote:
> Dionysius Wilson Almeida wrote:
> > 
> > Hi Everyone,
> > 
> > I'm using QLogic QLA104x PCI SCSI Adapter with HP CDWriter+ 9200.
> > The QLogic BIOS version is 6.14, ISP Firmware 4.50.
> > 
> > During the bootup, I see :
> > 
> > scsi : aborting command due to timeout : pid 6, scsi0, channel 0, id 6, lun 0 0x12 00 00 00 ff 00
> > 
> > But eventually it recognizes the CD Writer and configures it.
> 
> This looks like a scsi bus termination problem.
> 
> It seems as though the QLogic controller is ultra wide (16 bit)
> while the HP cdwriter is "scsi-2" (8 bit wide) and is the only
> thing on the scsi bus. How are you terminating the scsi bus with 
> this configuration?
> 
> Doug Gilbert
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
