From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 0/1] libosd bug fixing
Date: Wed, 02 Dec 2009 19:16:10 +0200
Message-ID: <4B16A0DA.5080205@panasas.com>
References: <4B15367C.9040405@panasas.com> <425904320912020131k46b34cdfmfa64a25196a5b44e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:27264 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754256AbZLBRQH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2009 12:16:07 -0500
In-Reply-To: <425904320912020131k46b34cdfmfa64a25196a5b44e@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vineet Agarwal <checkout.vineet@gmail.com>, James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

On 12/02/2009 11:31 AM, Vineet Agarwal wrote:
> Hi Boaz,
> 
> On Tue, Dec 1, 2009 at 9:00 PM, Boaz Harrosh <bharrosh@panasas.com
> <mailto:bharrosh@panasas.com>> wrote:
> 
>     James hi.
> 
>     Users have found an annoying bug in latest osd/exofs code. Actually this
>     deficiency exists for a long time, but only most recent exofs code has
>     exposed it.
> 
>     Please include the fix to the patches queued for 2.6.33. No need for it
>     to go into stable as current users will not hit it.
> 
>     [PATCH 1/1] libosd: Fix blk_put_request locking again
> 
>     Vineet Please test this new patch, the previous fix was crap
> 
> I applied the patch and it's working at my end.
> 

Thank you Vineet for testing. I was also able to reproduce the same problem
you had, and now it runs smoothly.

James please submit for 2.6.33. It is an important bug fix for the exofs code
that I want to push for next merge window.

Boaz
>     Thanks
>     Boaz
> 
> Regards:
> Vineet Agarwal
> 

