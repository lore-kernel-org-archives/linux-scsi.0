From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 10226] New: BusLogic Flashpoint SCSI Adapter
	not working with x86_64 kernels
Date: Wed, 12 Mar 2008 16:35:33 -0500
Message-ID: <1205357733.2941.160.camel@localhost.localdomain>
References: <bug-10226-10286@http.bugzilla.kernel.org/>
	 <47D825B5.7060201@panasas.com>
	 <1205348570.2941.140.camel@localhost.localdomain>
	 <200803122125.50161.us-@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34568 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752494AbYCLVfj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Mar 2008 17:35:39 -0400
In-Reply-To: <200803122125.50161.us-@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ulrich Schweitzer <us-@gmx.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2008-03-12 at 21:25 +0100, Ulrich Schweitzer wrote:
> Sorry for straying off topic, but this has to be the right crowd to ask:
> I assume that the driver won't be ported to x86_64 soon (if ever),

Not unless someone volunteers, but FlashPoint.c is huge.

>  so I'll 
> need a different SCSI adapter. Is the Adaptec AHA-2940 supported on x86_64 
> (those are cheap on ebay)? If not, what other, preferably cheap, SE SCSI 
> adapter would you recommend?

Yes, the adaptec 7xxx/79xx series work fine both on 64 bits and big
endian.

James


