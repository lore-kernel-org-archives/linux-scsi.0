From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Thu, 18 May 2006 20:28:32 -0700 (PDT)
Message-ID: <20060519032832.11025.qmail@web31805.mail.mud.yahoo.com>
References: <1147960665.3475.4.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31805.mail.mud.yahoo.com ([68.142.207.68]:28334 "HELO
	web31805.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S932177AbWESD2d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 23:28:33 -0400
In-Reply-To: <1147960665.3475.4.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Wed, 2006-05-17 at 19:39 -0700, Luben Tuikov wrote:
> > Apparently you have no detailed knowlege of the implementation of
> > SCSI storage stacks, for example: driver->fw->interconnect->device.
> 
> Well, I'm sure I read about it in a comic book somewhere ...

And so your correspondence agrees...

> > You also fail to understand who the "I" and "T" could be in an
> > I_T_x_x nexus at each stage of an implementation.
> > 
> > You also fail to understand that a SAM nexus is not necessarily
> > established
> > when queuecommand() is called. 
> 
> I didn't say it was.  The point, which you're ignoring, is that when the
> driver knows the SAM nexus is terminated, it should call ->done() ASAP

No, I'm not saying that.  Not at all.  You simply don't understand.

There is no way I can explain it to you unless I educate you.  And I'm not
willing to do that.

> to inform the mid-layer of this condition, so the mid-layer model of the
> device interactions follows the SAM interactions as closely as possible.
> The API you want to introduce and the implementation of it in libata lie
> to the mid-layer and pretend the nexus still exists when the driver
> knows it doesn't ... what I'm saying is that I see no reason to do that.

Stop trying to convince the world that SCSI Core has any resemblance
to SAM.  It doesn't.  It is a far cry from it.

There is no "mid-layer model" and there is no SAM resemblance.

     Luben

