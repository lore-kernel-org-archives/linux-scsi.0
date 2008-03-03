From: Tejun Heo <htejun@gmail.com>
Subject: Re: [BUG] 2.6.25-rc2-git3 broke cdrecord
Date: Mon, 03 Mar 2008 19:29:27 +0900
Message-ID: <47CBD307.2070603@gmail.com>
References: <20080302233415.GA6258@Pilar>	<18379.18297.838050.536473@harpo.it.uu.se>	<tkrat.468fd04c47ae1a2a@s5r6.in-berlin.de>	<20080303172641Z.fujita.tomonori@lab.ntt.co.jp>	<47CBC014.9090309@s5r6.in-berlin.de>	<18379.51360.744676.894510@harpo.it.uu.se> <18379.53492.171481.255371@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:4672 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbYCCK3e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2008 05:29:34 -0500
Received: by wf-out-1314.google.com with SMTP id 28so6788131wff.4
        for <linux-scsi@vger.kernel.org>; Mon, 03 Mar 2008 02:29:34 -0800 (PST)
In-Reply-To: <18379.53492.171481.255371@harpo.it.uu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, crmafra2@gmail.com, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Mikael Pettersson wrote:
> Mikael Pettersson writes:
>  > Stefan Richter writes:
>  >  > FUJITA Tomonori wrote:
>  >  > > On Mon, 3 Mar 2008 02:48:23 +0100 (CET)
>  >  > > Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>  >  > >> CD burning still fails for me via ide-cd, although in a
>  >  > >> different way than without the patch.  (Without the patch, ide-cd also
>  >  > >> fails like described by you for SATA.)
>  >  > >>
>  >  > >> With the patch, the failure is as follows.  I don't know if this is
>  >  > >> related to the data length arithmetic or something entirely different;
>  >  > >> all I learned so far is that 2.6.24 works.  Application log from
>  >  > >> 2.6.25-rc3 + Tejun's patch + Gentoo's cdrkit-1.1.6 + k3b:
>  >  > > 
>  >  > > Can you try the following patch?
>  >  > > 
>  >  > > http://lkml.org/lkml/2008/3/2/218
>  >  > 
>  >  > Fails just like with Tejun's patch, alas.
>  > 
>  > At this point I must confess I feel very uneasy about this situation.
>  > 
>  > Dare I suggest the perhaps hereditary solution of reverting these
>  > changes and doing them right after 2.6.25 final?
> 
> Doh! s/hereditary/heretical/

Please lemme track down a bit deeper.  I can reproduce seemingly similar
problem here.

Thanks.

-- 
tejun
