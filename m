From: Andrew Morton <akpm@digeo.com>
Subject: Re: aic7xxx woes in 2.5
Date: Sat, 14 Dec 2002 22:48:02 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DFC25A2.B497FA6@digeo.com>
References: <3DFC059A.9AA3F75F@digeo.com> <3DFC1BD2.F2F347C9@yk.rim.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id WAA26154
	for <linux-scsi@vger.kernel.org>; Sat, 14 Dec 2002 22:48:35 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: Ishikawa <ishikawa@yk.rim.or.jp>
Cc: linux-scsi@vger.kernel.org

Ishikawa wrote:
> 
> Hi,
> 
> > The parity error is intermittent.  But when it happens, the lockup
> > always happens.
> >
> > This never happens in 2.4 kernels.
> >
> > It seems to happen a little more frequently on uniprocessor builds.
> >
> > So relevant questions would be:
> >
> > 1) Why does only 2.5 get the parity error?
> 
> Since you say "uniprocessor builds", maybe you are using
> high-quality dual processor board. But just in case, does your
> motherboard support proper PCI parity bus check?

I expect it supports everything.  It is a 1998-vintage Intel
ad450nx server - these things cost $70,000 in their day.  It
is built like a battleship.  See
http://images.google.com/images?hl=en&lr=&ie=ISO-8859-1&q=ad450nx

But that error is a scsi bus error, not a PCI bus error.

> ...
> > scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.5
> >         <Adaptec 29160 Ultra160 SCSI adapter>
> >         aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
> >
> 
> I noticed that you have many disks.
> Are they in external enclosure?

They are internal.

> If not, is the power-supply in your
> PC box spec'ed to supply enough power?

It has four power supplies and approximately 13 fans ;)
