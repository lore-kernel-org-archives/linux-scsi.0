From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Adaptec 29320LPE errors on boot
Date: Wed, 05 Mar 2008 10:32:57 -0600
Message-ID: <1204734777.3047.40.camel@localhost.localdomain>
References: <a7108f870803050742x6a960bf4sed894208a5fb3931@mail.gmail.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F4831D6BEF@ADPE2K703.adaptec.com>
	 <a7108f870803050826u15e8dd90q656cd415e4eea1eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58095 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755564AbYCEQdA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 11:33:00 -0500
In-Reply-To: <a7108f870803050826u15e8dd90q656cd415e4eea1eb@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rodrigo Severo <rodrigo@fabricadeideias.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-03-05 at 13:26 -0300, Rodrigo Severo wrote:
> On 3/5/08, Salyzyn, Mark <Mark_Salyzyn@adaptec.com> wrote:
> > Sounds like you have a bad SCSI cable or drive.
> >
> >  Do any of these drives work in any other OS environment?
> 
> This same drive with this same cable with this same terminator works
> well with a 39160 (which usses another driver: the aic7xxx) on the
> same OS environment so I don't think this is a cable or drive issue.

That's only ultra 160 capable.  What happens if you take the speeds for
the drives down in the bios of the 29320?

> Besides I tested with four different cables (different models and
> manufactures, all pretend to be U320 compatible). The problem is
> unchanged when I use different cables and terminators.
> 
> I also tested with several different disks (different models and
> manufactures). The problem is still unchanged.

It's sounding a bit more like a damaged board ... but try reducing the
speed in the bios.

James


