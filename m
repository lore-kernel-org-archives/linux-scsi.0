From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: mpt2sas regression: can not add disk...
Date: Wed, 7 Dec 2011 23:24:57 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED70D912FF83D@inbmail01.lsi.com>
References: <7863850E8C98C748980632D9D3B7C19911968B8AE5@inbmail02.lsi.com>
	<A6888A6805518E4EA4AF7072A28264A604726F2824@inbmail02.lsi.com>
	<CAE9FiQWY-jhtbCmdfBY1zg_d0nreTHbkVe3CmaPQMgojDAtLaw@mail.gmail.com>
 <CAE9FiQXbu-O2exdhjziWCdiWWGNb8q7_RoECeKC5K80DEOobbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAE9FiQXbu-O2exdhjziWCdiWWGNb8q7_RoECeKC5K80DEOobbw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-scsi-owner@vger.kernel.org" <linux-scsi-owner@vger.kernel.org>, James Bottomley <jejb@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Yinghai,

I am trying to reproduce this issue locally and get back to you with my findings.


Thanks, Kashyap

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Yinghai Lu
> Sent: Wednesday, December 07, 2011 5:45 AM
> To: Nandigama, Nagalakshmi; James Bottomley; Rafael J. Wysocki
> Cc: linux-scsi-owner@vger.kernel.org; James Bottomley; linux-
> scsi@vger.kernel.org; Linux Kernel Mailing List
> Subject: Re: mpt2sas regression: can not add disk...
> 
> On Mon, Nov 28, 2011 at 12:00 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Sun, Nov 27, 2011 at 10:09 PM, Nandigama, Nagalakshmi
> > <Nagalakshmi.Nandigama@lsi.com> wrote:
> >> Yinghai Lu,
> >>
> >> Please set the driver logging level to 0x421F8 (echo 0x421F8 >
> >> /sys/module/mpt2sas/parameters/logging_level) and the scsi logging
> >> level to 0x180000F1 (echo 0x180000F1 >
> >> /proc/sys/dev/scsi/logging_level) and recreate the issue and provide
> >> the var/log/message
> >>
> >
> > please check two print out...
> 
> James,
> 
> one week passed, did not hear anything from the original author.
> 
> Can you  revert offending commit ?
> 
> it is 921cd8024b908f8f49f772c8d3a02381b4db2ed2
> and several related commits after that.
> 
> please check attached reverting patch that i used locally.
> 
> Thanks
> 
> Yinghai
