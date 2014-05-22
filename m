From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/2] scsi: hyper-v storvsc changes by Ubuntu
Date: Thu, 22 May 2014 07:38:16 -0700
Message-ID: <1400769496.2259.10.camel@dabdike.int.hansenpartnership.com>
References: <1400254748-21573-1-git-send-email-abbotti@mev.co.uk>
	 <CAO=4fJMamZvda-EKQx7SwH8yf8Q4YMR+gkhH7Yy0mUYHZZM0iA@mail.gmail.com>
	 <3fdc70fd644041d5975b4d1427571f78@BY2PR03MB299.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40317 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498AbaEVOiT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 May 2014 10:38:19 -0400
In-Reply-To: <3fdc70fd644041d5975b4d1427571f78@BY2PR03MB299.namprd03.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: Andy Whitcroft <apw@canonical.com>, Ian Abbott <abbotti@mev.co.uk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, Haiyang Zhang <haiyangz@microsoft.com>, Tim Gardner <tim.gardner@canonical.com>

On Thu, 2014-05-22 at 10:49 +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Andy Whitcroft [mailto:apw@canonical.com]
> > Sent: Wednesday, May 21, 2014 7:25 AM
> > To: Ian Abbott
> > Cc: linux-scsi@vger.kernel.org; devel@linuxdriverproject.org; KY Srinivasan;
> > Haiyang Zhang; James E.J. Bottomley; Tim Gardner
> > Subject: Re: [PATCH 0/2] scsi: hyper-v storvsc changes by Ubuntu
> > 
> > On 16 May 2014 16:39, Ian Abbott <abbotti@mev.co.uk> wrote:
> > > These changes to the Microsoft Hyper-V storage driver in Ubuntu
> > > Saucy's
> > > 3.13 kernel look useful for the mainline kernel, especially as they
> > > enable 'TRIM' support.
> > >
> > > Andy Whitcroft (2):
> > >   scsi: hyper-v storvsc switch up to SPC-3
> > >   scsi: hyper-v storvsc -- host takes MAINTENANCE_IN commands badly --
> > >     elide them
> > >
> > >  drivers/scsi/storvsc_drv.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > 
> > 
> > The back story here is a little complex.  The main issue is that the Hyper-V
> > drives claim to be SPC-2, and yet implement the SPC-3 extensions for TRIM.
> > We did attempt to upstream quirks to allow these features to be negotiated
> > specifically for the Hyper-V virtual drives (minimum regression potential) but
> > these were NAKd, and it was suggested that just overriding the Hyper-V
> > drives to SPC-3 unconditionally was more appropriate.  The first of the
> > patches here does does this.  This has been sitting in our tree for some time
> > as it was not clear that this would be entirely safe, though the SPC-3 bits are
> > in theory at least mostly detected.  That said this change has been in Ubuntu
> > for a full cycle now and does not seem to have caused any issues.  If KY is
> > happy we should likely submit it formally.  The second fix I believed was
> > already being submitted to mainline.
> > 
> > KY?
> 
> The Windows guys are not currently comfortable claiming conformance to
> SPC-3, as they have not done
> the necessary testing. This will change hopefully soon.

Any bounds on the value of "soon" are we talking weeks or months?  I
think trim is a feature, which means no huge rush to get this in, but it
is nice to respond in a timely fashion to a request from a distribution
to enable a useful feature.

James


