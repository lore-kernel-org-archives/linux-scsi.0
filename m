From: rkuo <rkuo@codeaurora.org>
Subject: Re: [PATCH] drivers: scsi: scsi_lib.c: add prefix "SCSILIB_" to
 macro "SP"
Date: Mon, 2 Dec 2013 15:32:43 -0600
Message-ID: <20131202213243.GA20646@codeaurora.org>
References: <528AEFB7.4060301@gmail.com>
 <20131125011938.GB18921@codeaurora.org>
 <5292B845.3010404@gmail.com>
 <5292B8A0.7020409@gmail.com>
 <5294255E.7040105@gmail.com>
 <52955913.3060809@gmail.com>
 <529B60FF.7030601@acm.org>
 <529BD584.7060504@gmail.com>
 <1385945387.20150.2.camel@dabdike.int.hansenpartnership.com>
 <529C5D89.8050809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <529C5D89.8050809@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@acm.org>, Bottomley@parallels.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 02, 2013 at 06:14:33PM +0800, Chen Gang wrote:
> If one issue occurs, normally, both sides need improvement.
> 
> For our issue:
> 
>  - need try to keep uapi no touch ("arch/hexagon/uapi/asm/registers.h").
> 
>  - improving our module is much easier than improving hexagon.
> 
>  - for 'SP', it is really short enough to like a register name.
>    SG_POOL seems more suitable for our 'sgpool' related operations.
> 
> 
> It will be better to improve hexagon too, but it is not quit easy (maybe
> have to bear it), it is uapi :-(

I can't speak for SCSI, but that define in Hexagon isn't really used outside
of that file anyways (the two SP macros themselves).  I'm also pretty sure
the userspace isn't currently using it anyways.  Seeing as it's not really
buying us anything, I'm fine with just removing it and continuing to review
the other defines.  I'll make that change and test it locally.


Thanks,
Richard Kuo


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
