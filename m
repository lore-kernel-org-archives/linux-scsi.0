From: "Michael P. Carel" <mikecarel@teamglac.com>
Subject: Re: Address or Write Phase Parity Error in  Adaptec Ultra320(29320)
Date: Mon, 14 Apr 2003 13:35:35 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <00b601c30247$ac4bfae0$8601a8c0@teamglac.com>
References: <005901c30229$735b8c00$8601a8c0@teamglac.com> <2555792704.1050287878@aslan.scsiguy.com><001d01c3022f$ab3806c0$8601a8c0@teamglac.com> <2574772704.1050290648@aslan.scsiguy.com> <008501c30240$b7049840$8601a8c0@teamglac.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from team5.teamglac.com ([203.87.142.130]:12044 "HELO
	team5.teamglac.com") by vger.kernel.org with SMTP id S262763AbTDNFhG (for <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2003 01:37:06 -0400
Received: (from root@localhost)
	by team5.teamglac.com (8.9.3/8.9.3) id NAA29289
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2003 13:43:37 +0800
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org


Justin,

thanks  for the tips, my scsi now works fine, i've change my cnet network
card to 3com network card. CNET network card give a parity error to my
Adaptec Ultra320(29320) scsi card.


Mike




----- Original Message -----
From: "Michael P. Carel" <mikecarel@teamglac.com>
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: <linux-scsi@vger.kernel.org>
Sent: Monday, April 14, 2003 12:45 PM
Subject: Re: Address or Write Phase Parity Error in Adaptec Ultra320(29320)


> changing slots doesnt change anything but removing the network make the
scsi
> work fine, but i need a network in this machine. What should i do?
>
> ----- Original Message -----
> From: "Justin T. Gibbs" <gibbs@scsiguy.com>
> To: "Michael P. Carel" <mikecarel@teamglac.com>
> Sent: Monday, April 14, 2003 11:24 AM
> Subject: Re: Address or Write Phase Parity Error in Adaptec
Ultra320(29320)
>
>
> > > attached was the dmesg and the lspci output. I'm using EPOX 4G4A with
> Intel
> > > chipset that have  a 32bit PCI slots.
> >
> > Some things to try:
> >
> > 1) Do you still get these messages when drivers for most other
peripherals
> > are not loaded (no sound, no ethernet, no ide, etc).
> >
> > 2) Does the behavior change when you change slots?
> >
> > I don't have a lot of experience with the 845xx chipsets, but you may
> > be able to avoid the problem by moving the 29320 to a bus that is not
> > getting strafed by some device sending out PCI transactions with bad
> > parity.
> >
> > --
> > Justin
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

