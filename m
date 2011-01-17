From: Tejun Heo <tj@kernel.org>
Subject: Re: PMP and SEMB messages to SEP
Date: Mon, 17 Jan 2011 18:39:46 +0100
Message-ID: <20110117173946.GL27123@htj.dyndns.org>
References: <20110113192558.GE16039@MAIL.13thfloor.at>
 <20110114142018.GA978@htj.dyndns.org>
 <20110114165957.GH16039@MAIL.13thfloor.at>
 <20110114170407.GE978@htj.dyndns.org>
 <20110114173759.GI16039@MAIL.13thfloor.at>
 <20110117154042.GG27123@htj.dyndns.org>
 <1295281131.3015.44.camel@mulgrave.site>
 <20110117171312.GL16039@MAIL.13thfloor.at>
 <20110117172054.GJ27123@htj.dyndns.org>
 <20110117173433.GM16039@MAIL.13thfloor.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49606 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab1AQRjx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jan 2011 12:39:53 -0500
Content-Disposition: inline
In-Reply-To: <20110117173433.GM16039@MAIL.13thfloor.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Herbert Poetzl <herbert@13thfloor.at>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Jan 17, 2011 at 06:34:33PM +0100, Herbert Poetzl wrote:
> hmm, haven't had the time to dig through the specs yet, but
> at least addonics seems to disagree here:
> 
> http://www.addonics.com/products/host_controller/tutorial_pm.asp
> 
> but maybe that's just a marketing page with no relation
> to reality ....

That's hardware RAID PMP.  It would just show up as a single drive to
the host.  They can do whatever they want to if they do that.

> > AFAIK, it just doesn't care.  It could be ses-2 or whatever else.  It
> > just transmits the binary blob it receives via sysfs and vice-versa.
> 
> the interesting part here is, that the AHCI host controller
> my PMP is connected to recognizes the PMP perfectly fine
> (i.e. more than one drive works just as expected), but doesn't
> seem to allow for the em_message part (despite the fact that
> the attached PMP seems to be SEMB/SEP capable) ...
> 
> maybe this is just a bug in the kernel code, maybe the AHCI
> implementation doesn't allow a PMP to receive enclosure
> management messages at all ...

AFAIK, the ahci em message thing is not via PMP.  It's for cases where
the ahci controller is directly connected to an enclosure.  Well,
that's my understanding anyway.

-- 
tejun
