From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] fix id computation in scsi_eh_target_reset()
Date: Tue, 14 Dec 2010 21:31:20 -0500
Message-ID: <1292380280.19511.11.camel@mulgrave.site>
References: <AANLkTin-Tkj3Ab312usO2FWE57m3St2iG2oz881F-Zhw@mail.gmail.com>
	 <4CBBDC19.1090806@cs.wisc.edu> <1288040021.5487.826.camel@mulgrave.site>
	 <4CC75F42.9030603@cs.wisc.edu> <1288134569.19649.5.camel@mulgrave.site>
	 <4CC86CF5.1080204@cs.wisc.edu>  <4D07DA3C.2080209@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab0LOCbo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Dec 2010 21:31:44 -0500
In-Reply-To: <4D07DA3C.2080209@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hillf Danton <dhillf@gmail.com>, linux-scsi@vger.kernel.org

On Tue, 2010-12-14 at 14:57 -0600, Mike Christie wrote:
> Hey James,
> 
> Your patch with the _init fixed the problem for me. Were you going to 
> merge the patch or did you want me to test Hilf's version?

Well, it's actually been in scsi-misc for a while ... of course, I
forgot to do the _init fix (now corrected):

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=038d1001945812e49b7fcc29ce2960bcbfaecb16

James


