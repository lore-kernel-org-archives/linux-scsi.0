From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Wed, 25 Mar 2009 05:58:40 -0700
Message-ID: <027157EF-0507-4193-9F77-A414EBCD84A1@qlogic.com>
References: <1227043498.4949.21.camel@ogier> <1234365225.24194.3.camel@ogier> <3F3E8B49-EB9A-4A6D-ABB0-3F4FC2EF7D1C@qlogic.com> <BAD9A31D-BCDA-46F9-AE12-E310B684498F@qlogic.com> <49BC2CCF.2050105@emulex.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:25965 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbZCYM6o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Mar 2009 08:58:44 -0400
In-Reply-To: <49BC2CCF.2050105@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "sven@linux.vnet.ibm.com Schuetz" <sven@linux.vnet.ibm.com>, "futjita.tomonori@lab.ntt.co.jp" <futjita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>


On Mar 14, 2009, at 3:16 PM, James Smart wrote:

> Thank you Seokmann. I'm glad the RFC worked well for you.  Your  
> patch is
> appreciated, it was the portion that needed to be reverted as the
> collapsed blk_end_request() patch wasn't taken.  To double check -  
> there
> are no patches required with the RFC now - right ?
>
> I'll repost as a non-RFC, and we'll see where James takes it.
Could you share your plan on this?
Just trying to figure out when we will have it in the upstream tree,  
hoping that 2.6.30 is viable target.

Thank you,
Seokmann
