From: Matthias Jaenichen <mj2@percomp.de>
Subject: RE: SCSI IO Errors
Date: Tue, 09 Sep 2003 18:36:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4.3.2.7.2.20030909183554.035b77c0@127.0.0.1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.percomp.de ([192.88.4.5]:1415 "HELO gateway.percomp.de")
	by vger.kernel.org with SMTP id S264222AbTIIQk1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Sep 2003 12:40:27 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

At 11:36 09.09.03 -0400, Cress, Andrew R wrote:
>Matthias,
>
>I noticed that you have a mix of speeds (20, 20, & 10) on the bus

that is a bridged bus with only ID=0 od LVD, the others on the wide/fast 
connectors.

But at the moment there is only the HDD and the CD connected.

<Contr. (7)>-----+-----+-----+----+----+
  Term internal   B     H               T
                  r     D               E
                  i     D               R
                  d    (0)              M
                  g
                  e
        50pin<----+----> wide--+-------->TERM2
                  Term.        CDrom
                  internal     (2)


>, and the max tagged command queue is 253.

where did you get that from? I have a log entry saying 49!!

>  You may see better results by
>reducing this to 32 in the kernel config.
>   CONFIG_AIC7XXX_CMDS_PER_DEVICE=32

I can try that...

>But if the termination is ok, and since you have already said that you
>swapped the cables, the disk firmware should be the next thing to check,

checked, no result

>with Seagate.
>
>Andy
>
>At 18:47 07.09.03 +0100, Alan Cox wrote:
> >On Sad, 2003-09-06 at 19:59, Matthias Jaenichen wrote:
> > > (scsi0:A:0): 20.000MB/s transfers (10.000MHz, offset 31, 16bit)
> > >    Vendor: SEAGATE   Model: ST318436LW        Rev: 0010
> > >    Type:   Direct-Access                      ANSI SCSI revision: 03
> >
>[...snip...]
>
>What does "Locking max tag count at" mean and why does it only come up
>from
>time to time?

