From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: out of range LBA using sg_raw
Date: Wed, 8 Mar 2017 21:45:51 +0530
Message-ID: <2eaa0bc260592a1ab8fa5184261091c0@mail.gmail.com>
References: <cf343e80707394b8945cd7643f7beecd@mail.gmail.com>
         <20170308151113.GB27450@infradead.org>  <eb88925faa247b2ae6e510fc7fd0cff9@mail.gmail.com>
 <1488989079.2813.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:35663 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbdCHQPz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2017 11:15:55 -0500
Received: by mail-qk0-f174.google.com with SMTP id v125so72329050qkh.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Mar 2017 08:15:54 -0800 (PST)
In-Reply-To: <1488989079.2813.1.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Bart Van Assche [mailto:Bart.VanAssche@sandisk.com]
> Sent: Wednesday, March 08, 2017 9:35 PM
> To: hch@infradead.org; kashyap.desai@broadcom.com
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: out of range LBA using sg_raw
>
> On Wed, 2017-03-08 at 21:29 +0530, Kashyap Desai wrote:
> > Also one more fault I can generate using below sg_raw command -
> >
> > "sg_raw -r 32k /dev/sdx 28 00 01 4f ff ff 00 00 08 00"
> >
> > Provide more scsi data length compare to actual SG buffer. Do you
> > suggest such SG_IO interface vulnerability is good to be captured in
driver.
>
> That's not a vulnerability of the SG I/O interface. A SCSI device has to
set the
> residual count correctly if the SCSI data length does not match the size
of the
> data buffer.

Thanks Bart.  I will pass this information to Broadcom firmware dev. May
be a Tx/Rx (DMA) related code in MR (also for Fusion IT HBA)  cannot
handle due to some sanity checks are not passed.

>
> Bart.
