From: Andrew Randrianasulu <randrianasulu@gmail.com>
Subject: Re: Fwd: Re: kernel BUG at drivers/scsi/scsi_error.c:197! - git 4.17.0-x64-08428-g7d3bf613e99a
Date: Thu, 14 Jun 2018 01:33:51 +0300
Message-ID: <201806140133.52354.randrianasulu@gmail.com>
References: <201806130602.59441.randrianasulu@gmail.com> <3ab38d8d65c34d4109195f29bae61429f30b13aa.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3ab38d8d65c34d4109195f29bae61429f30b13aa.camel@wdc.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "rdunlap@infradead.org" <rdunlap@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

=D0=92 =D1=81=D0=BE=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D0=B8 =D0=BE=D1=82 =
Wednesday 13 June 2018 16:05:07 Bart Van Assche =D0=BD=D0=B0=D0=BF=D0=B8=D1=
=81=D0=B0=D0=BB(=D0=B0):
> On Wed, 2018-06-13 at 06:02 +0300, Andrew Randrianasulu wrote:
> > after retesting with git up to
> > 4.17.0-x64-11701-g4597fcff0704-dirty
> >
> > BUG line is gone , yet s2ram still not working:
>
> Hello Andrew,
>
> Have you already verified whether s2ram works again after having applied
> Jianchao's patch?

yes, double-verified (I put my machine to sleep while I also was sleeping).=
=20
Still running ok.

>
> Thanks,
>
> Bart.
