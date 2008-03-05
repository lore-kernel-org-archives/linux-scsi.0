From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Adaptec 29320LPE errors on boot
Date: Wed, 05 Mar 2008 11:10:26 -0600
Message-ID: <1204737026.3047.45.camel@localhost.localdomain>
References: <a7108f870803050742x6a960bf4sed894208a5fb3931@mail.gmail.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F4831D6BEF@ADPE2K703.adaptec.com>
	 <a7108f870803050826u15e8dd90q656cd415e4eea1eb@mail.gmail.com>
	 <1204734777.3047.40.camel@localhost.localdomain>
	 <a7108f870803050852h1824418v9c67a90f754f69e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57173 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754378AbYCERKa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 12:10:30 -0500
In-Reply-To: <a7108f870803050852h1824418v9c67a90f754f69e@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rodrigo Severo <rodrigo@fabricadeideias.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-03-05 at 13:52 -0300, Rodrigo Severo wrote:
> On 3/5/08, James Bottomley <James.Bottomley@hansenpartnership.com> wrote:
> > On Wed, 2008-03-05 at 13:26 -0300, Rodrigo Severo wrote:
> >  > On 3/5/08, Salyzyn, Mark <Mark_Salyzyn@adaptec.com> wrote:
> >  > > Sounds like you have a bad SCSI cable or drive.
> >  > >
> >  > >  Do any of these drives work in any other OS environment?
> >  >
> >  > This same drive with this same cable with this same terminator works
> >  > well with a 39160 (which usses another driver: the aic7xxx) on the
> >  > same OS environment so I don't think this is a cable or drive issue.
> >
> > That's only ultra 160 capable.  What happens if you take the speeds for
> >  the drives down in the bios of the 29320?
> 
> I changed the following values on  29320LPE from the previous default ones:
> 
> Sync Transfer Rate: 160
> Packetized: No
> QAS: No
> 
> The error messages are unchanged.

That does point further to card problems.

> >  > Besides I tested with four different cables (different models and
> >  > manufactures, all pretend to be U320 compatible). The problem is
> >  > unchanged when I use different cables and terminators.
> >  >
> >  > I also tested with several different disks (different models and
> >  > manufactures). The problem is still unchanged.
> >
> > It's sounding a bit more like a damaged board ... but try reducing the
> >  speed in the bios.
> 
> As I said before, you have much more experience on SCSI issues but I
> still can't see how a damaged SCSI board would work on one motherboard
> model. Do you really think this is possible?

Certainly ... depends on the problem ... for instance, you could have a
damaged trace in the high 32 bits and not see the problem when you put
it in a 32 bit slot.  Likewise, it could be a capacitance problem on the
traces and your motherboard that works has a lower PCI bus speed.

The fact that it works in one system tends to rule out software driver
problems.  If you've tried different cables and reducing the speed, that
tends to eliminate the interconnect, so all that's left is the card (and
the motherboards, I suppose, although three failing would tend to rule
them out).

James




