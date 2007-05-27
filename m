From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 5/5] SCSI/initio conversion to PCI driver API
Date: Sun, 27 May 2007 10:12:19 -0500
Message-ID: <1180278739.3711.16.camel@mulgrave.il.steeleye.com>
References: <20070527145200.GA17017@havoc.gtf.org>
	 <20070527145955.GE17085@havoc.gtf.org>  <46599DD9.4020408@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:36696 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753701AbXE0PMW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 May 2007 11:12:22 -0400
In-Reply-To: <46599DD9.4020408@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>

On Sun, 2007-05-27 at 11:03 -0400, Jeff Garzik wrote:
> Jeff Garzik wrote:
> > Prior simplifications in this patchset now permit a minimal conversion
> > to the new PCI API.
> > 
> > Further improvements and simplifications are certainly possible; those
> > should be presented in a separate patchset.
> > 
> > DO NOT APPLY (yet).  For feedback (and testers?) only.
> 
> 
> This only applies to patch #5.
> 
> Patches 1 through 4 should go upstream, IMO.

Erm, actually, you're treading all over Alan:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=72d39fea9017bbb1407620bf89dfe8d1fb658e35

Could you rebase your patches to scsi-misc-2.6 and resubmit (if there's
anything Alan hasn't covered)?

Thanks,

James


