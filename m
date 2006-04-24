From: Andrew Morton <akpm@osdl.org>
Subject: Re: Fw: [BUG] 2.6.17-rc1: SCSI kobject_add problems
Date: Mon, 24 Apr 2006 13:15:08 -0700
Message-ID: <20060424131508.72bf2f15.akpm@osdl.org>
References: <444CE9A6.6030304@sgi.com>
	<20060424185533.6229EDBA1@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:51350 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750971AbWDXUQv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Apr 2006 16:16:51 -0400
In-Reply-To: <20060424185533.6229EDBA1@gherkin.frus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bob Tracy <rct@gherkin.frus.com>
Cc: mdr@sgi.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>

rct@gherkin.frus.com (Bob Tracy) wrote:
>
> My "kobject_add failed" issue with 2.6.17-rc1 and -rc2 was a previously
>  undiscovered code error in the Alpha-specific strncpy() routine.  See
>  http://marc.theaimsgroup.com/?t=114555387000005&r=1&w=2
>  for the gory details.  Ivan Kokshaysky provided the fix, which I hope
>  has been captured for inclusion in -rc3.

I don't have Ivan's strncpy() fix and I don't think it's in mainline either.

Ivan, pelase send it over when it's ready?
