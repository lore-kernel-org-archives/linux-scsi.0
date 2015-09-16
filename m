From: Ian Munsie <imunsie@au1.ibm.com>
Subject: Re: [PATCH 00/29] cxlflash: Miscellaneous bug fixes and corrections
Date: Wed, 16 Sep 2015 12:50:22 +1000
Message-ID: <1442371641-sup-310@delenn.ozlabs.ibm.com>
References: <1442006012-46803-1-git-send-email-mrochs@linux.vnet.ibm.com> <1442188796-sup-7396@delenn.ozlabs.ibm.com> <8867AAC7-E67D-48B6-93DD-454B96F5979A@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:34538 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbbIPCvb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2015 22:51:31 -0400
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <imunsie@au1.ibm.com>;
	Wed, 16 Sep 2015 12:51:29 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 951C42BB0054
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 12:51:26 +1000 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8G2pJIs62062630
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 12:51:27 +1000
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8G2orDa022741
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 12:50:54 +1000
In-reply-to: <8867AAC7-E67D-48B6-93DD-454B96F5979A@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, "James.Bottomley" <James.Bottomley@HansenPartnership.com>, nab <nab@linux-iscsi.org>, brking <brking@linux.vnet.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, "andrew.donnellan" <andrew.donnellan@au1.ibm.com>, mikey <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org

Hi Matt & Manoj,

Can you also add linuxppc-dev@lists.ozlabs.org to the Cc list for
version 2?

Cheers,
-Ian

Excerpts from Matthew R. Ochs's message of 2015-09-15 06:12:29 +1000:
> > On Sep 13, 2015, at 8:12 PM, Ian Munsie <imunsie@au1.ibm.com> wrote:
> > 
> > Hi Matt & Manoj,
> > 
> > Just a general comment about this series - I'd like to see more detailed
> > commit messages for almost all these patches. Of course James is the
> > scsi maintainer and it's up to him whether to take these as is or not,
> > but generally when you write a commit message for a bug fix you want to
> > explain:
> > 
> > - What problem can occur, possibly including an example
> > - Why it occurs
> > - How this patch addresses it
> > 
> > You don't necessarily need to go overboard because at some point people
> > can just read the code, but some of these patches don't have any detail
> > beyond a single subject line, which is too little.
> > 
> > Speaking of the subject line - if the patch is fixing a bug there should
> > be some indication of that in the subject (it should probably include
> > the word "fix" somewhere). If the subject just states what you are
> > changing then it's not immediately obvious that it is a bug fix.
> 
> This is a reasonable request. Will incorporate your suggestions
> and send out in a v2 series. Thanks for the examples of what you
> would like to see.
> 
> 
> -matt

