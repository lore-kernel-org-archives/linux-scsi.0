From: Matthias Jaenichen <mj2@percomp.de>
Subject: Re: SCSI IO Errors
Date: Tue, 09 Sep 2003 16:51:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4.3.2.7.2.20030909162940.03fef220@127.0.0.1>
References: <4.3.2.7.2.20030906201331.023a82c0@127.0.0.1>
 <4.3.2.7.2.20030906171159.02737a10@127.0.0.1>
 <4.3.2.7.2.20030906171159.02737a10@127.0.0.1>
 <4.3.2.7.2.20030906201331.023a82c0@127.0.0.1>
 <1062956848.16964.26.camel@dhcp23.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.percomp.de ([192.88.4.5]:42883 "HELO gateway.percomp.de")
	by vger.kernel.org with SMTP id S264163AbTIIOzc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Sep 2003 10:55:32 -0400
In-Reply-To: <1062956848.16964.26.camel@dhcp23.swansea.linux.org.uk>
References: <4.3.2.7.2.20030906201331.023a82c0@127.0.0.1>
 <4.3.2.7.2.20030906171159.02737a10@127.0.0.1>
 <4.3.2.7.2.20030906171159.02737a10@127.0.0.1>
 <4.3.2.7.2.20030906201331.023a82c0@127.0.0.1>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jan-Benedict Glaw <jbglaw@lug-owl.de>, linux-scsi@vger.kernel.org

Hi Alan!

Thanks for joining in again.

At 18:47 07.09.03 +0100, Alan Cox wrote:
>On Sad, 2003-09-06 at 19:59, Matthias Jaenichen wrote:
> > (scsi0:A:0): 20.000MB/s transfers (10.000MHz, offset 31, 16bit)
> >    Vendor: SEAGATE   Model: ST318436LW        Rev: 0010
> >    Type:   Direct-Access                      ANSI SCSI revision: 03
>
> >From the traces the disk is stopping responding, it then fails to
>react to an abort and your trace ends at the reset issue so its hard to
>see what happened then.

How to find out? Can I divert the SCSI-Output to the HDA somehow?


>Does seatools show up anyting on the disk ?

All available tests runperfectly. SCSI-BIOS can run for hours. IBMs 
Disktool also causes no trouble.

>Adaptec themselves have a forum for this stuff which is maintained by
>Justin Gibbs, the aic7xxx author

Jan-Benedict spent already a long time with me on the phone discussing 
various issues. He thinks there is something weird in the cabeling, 
although the setup looks ok, and all HW has been changed also.

I think there is a bug somewhere in the driver....

What does "Locking max tag count at" mean and why does it only come up from 
time to time?

Where can I find that forum? Adaptec's LINUX-pages do not show a forum.

Thanks!




