From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Do we need to implement sr START/STOP management
Date: Tue, 01 Nov 2011 16:35:36 +0400
Message-ID: <1320150936.17402.10.camel@dabdike>
References: <CADyp2PebObcVyMAA=XzTayiXmBxYRJtR3xY6b3tJYiVA=hCaqQ@mail.gmail.com>
	 <1320126812.7701.17.camel@dabdike>
	 <CADyp2Pdac=z6KzKnNykBCZNRLnjkv-z901Hwd-U0o2wB2qHWOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37134 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754522Ab1KAMgH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2011 08:36:07 -0400
In-Reply-To: <CADyp2Pdac=z6KzKnNykBCZNRLnjkv-z901Hwd-U0o2wB2qHWOA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JiSheng Zhang <jszhang3@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Tue, 2011-11-01 at 14:35 +0800, JiSheng Zhang wrote:
> 2011/11/1 James Bottomley <James.Bottomley@hansenpartnership.com>:
> > On Tue, 2011-11-01 at 13:31 +0800, JiSheng Zhang wrote:
> >> Currently, there's no start/stop management in scsi cdrom driver to
> >> spin up/down the motor do we need to implement it?
> >
> > Say more ... like what you think it buys.  The auto spin down of a CD
> > tends to be the best power control we have and it's not even clear that
> > manufacturers have implemented any other useful power states.
> 
> Does it mean the behavior depends on manufacturers? Some cd will spin
> down automatically?

All CDs spin down when not reading (or burning) since the motor power is
pretty high.  Most also do speed adjustments on the fly as well to try
to match platter speed and read or burn rate.

>  Even so, how about during shutdown just after reading
> something from cdrom?

What's the use case?  For internal CDs, shutdown removes power anyway.

James


