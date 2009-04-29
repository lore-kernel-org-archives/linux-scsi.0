From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/4] sd: fix cache flushing message
Date: Wed, 29 Apr 2009 14:36:40 -0600
Message-ID: <20090429203639.GB8822@parisc-linux.org>
References: <200904292206.29844.bzolnier@gmail.com> <1241036401.3369.57.camel@mulgrave.int.hansenpartnership.com> <49F8B71B.90707@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56438 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbZD2Ugk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2009 16:36:40 -0400
Content-Disposition: inline
In-Reply-To: <49F8B71B.90707@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-scsi@vger.kernel.org

On Wed, Apr 29, 2009 at 04:22:51PM -0400, Jeff Garzik wrote:
>> So you want it to say 
>>
>> sda: synchronizing disk cache
>>
>> instead of
>>
>> sda: synchronizing SCSI cache
>>
>> I don't really see that buying us anything in terms of clarity.  What's
>> the actual problem it solves?
>
> Indeed.
>
> And we can argue for weeks about English text, too.  Non-disk devices  
> like SSDs have caches too, so I'd say "SCSI cache" is more accurate than  
> "disk cache".  But maybe "SCSI writeback cache" would be even better.

"drive cache" works better (and avoids the whole disc/disk discussion too)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
