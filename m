From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Sat, 14 Mar 2009 18:16:47 -0400
Message-ID: <49BC2CCF.2050105@emulex.com>
References: <1227043498.4949.21.camel@ogier> <1234365225.24194.3.camel@ogier> <3F3E8B49-EB9A-4A6D-ABB0-3F4FC2EF7D1C@qlogic.com> <BAD9A31D-BCDA-46F9-AE12-E310B684498F@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:55414 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbZCNWRD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Mar 2009 18:17:03 -0400
In-Reply-To: <BAD9A31D-BCDA-46F9-AE12-E310B684498F@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "sven@linux.vnet.ibm.com Schuetz" <sven@linux.vnet.ibm.com>, "futjita.tomonori@lab.ntt.co.jp" <futjita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>

Thank you Seokmann. I'm glad the RFC worked well for you.  Your patch is 
appreciated, it was the portion that needed to be reverted as the 
collapsed blk_end_request() patch wasn't taken.  To double check - there 
are no patches required with the RFC now - right ?

I'll repost as a non-RFC, and we'll see where James takes it.

-- james s

Seokmann Ju wrote:
> On Feb 11, 2009, at 7:43 AM, Seokmann Ju wrote:
>   
> Here is a change that I've made for transport layer while I'm testing
> the feature.
> ---
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/
> scsi_transport_fc.c
> index 63ab7bc..4bca164 100644
>   
<snip...>
> With this change, I'm able to issue several ELS/CT services to the
> qla2xxx module for those registered to the transport layer and have
> rport associated with them.
>
> And, below is the driver changes for just review purpose.
>
> Do we have time table for this support to make it available in the
> upstream?
> I think it would be good to have the feature in 2.6.30 kernel, if
> possible.
> I will continue to work on and add rest of helper function in the
> driver.
>
> Thank you,
> Seokmann
>   
