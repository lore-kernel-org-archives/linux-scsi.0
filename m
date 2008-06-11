From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 4 of 7] block: bio data integrity support
Date: Wed, 11 Jun 2008 13:41:41 -0400
Message-ID: <x491w3398dm.fsf@segfault.boston.devel.redhat.com>
References: <f2ae9d5bce4c33e12083.1212814537@sermon.lab.mkp.net>
	<x491w359fne.fsf@segfault.boston.devel.redhat.com>
	<yq1r6b4mx9y.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbYFKRlo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2008 13:41:44 -0400
In-Reply-To: <yq1r6b4mx9y.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Wed, 11 Jun 2008 00:05:29 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

>>>>>> "Jeff" == Jeff Moyer <jmoyer@redhat.com> writes:
> Jeff> Hmm, up until this point you use bi to mean bio_integrity, but
> Jeff> now it means blk_integrity.  Confusion will ensue.  ;)
>
> Err, uhm.  There is no bio_integrity.  There's the bio integrity
> payload which I always refer to as struct bip *bip.  And struct
> blk_integrity which is always bi.  I'm also anal about using bv for
> the data bio_vec and iv for the integrity bio_vec.  I can't see any
> place where I'm inconsistent.

Wow, I have no idea where I got that impression.  Sorry!

> Jeff> struct blk_integrity_exchg is not yet defined in your patch set,
> Jeff> so this will likely break git bisect.
>
> bio-integrity.patch and blk-integrity.patch are artificially split up
> to ease the review process.  They are not meant to be separate
> changesets.

OK, just wanted to make sure you were aware of it.

Cheers,

Jeff
