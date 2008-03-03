From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [BUG] 2.6.25-rc2-git3 broke cdrecord
Date: Mon, 03 Mar 2008 17:26:41 +0900
Message-ID: <20080303172641Z.fujita.tomonori@lab.ntt.co.jp>
References: <20080302233415.GA6258@Pilar>
	<18379.18297.838050.536473@harpo.it.uu.se>
	<tkrat.468fd04c47ae1a2a@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:45334 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbYCCI1l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2008 03:27:41 -0500
In-Reply-To: <tkrat.468fd04c47ae1a2a@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stefanr@s5r6.in-berlin.de
Cc: mikpe@it.uu.se, crmafra2@gmail.com, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, htejun@gmail.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 3 Mar 2008 02:48:23 +0100 (CET)
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> [resend with linux-ide and linux-scsi CCed]
> 
> Mikael Pettersson wrote:
> > Carlos R. Mafra writes:
> >  > On Sun  2.Mar'08 at 21:53:25 +0100, Mikael Pettersson wrote:
> >  > > On my main workstation (Intel P965 chipset, ICH8 SATA driven by ahci,
> >  > > Samsung/Toshiba SH-203P SATA DVD writer, FC5 user-space), cdrecord
> >  > > stopped working on the 2.6.25-rc3 kernel, with the complaint:
> >  > > 
> >  > > Warning: controller returns zero sized CD capabilities page.
> >  > > Warning: controller returns wrong page 0 for CD capabilities page (2A).
> [...]
> >  > I will try to help by pointing you to the patch here: 
> >  > http://lkml.org/lkml/2008/2/28/76
> >  > 
> >  > It seems your problem is similar to the one Mike Galbraith reported.
> > 
> > That patch does seem to fix the problem. Thanks.
> 
> This also fixes the same regression for FireWire.
> 
> However, CD burning still fails for me via ide-cd, although in a
> different way than without the patch.  (Without the patch, ide-cd also
> fails like described by you for SATA.)
> 
> With the patch, the failure is as follows.  I don't know if this is
> related to the data length arithmetic or something entirely different;
> all I learned so far is that 2.6.24 works.  Application log from
> 2.6.25-rc3 + Tejun's patch + Gentoo's cdrkit-1.1.6 + k3b:

Can you try the following patch?

http://lkml.org/lkml/2008/3/2/218

Thanks,
