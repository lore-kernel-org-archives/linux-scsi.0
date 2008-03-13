From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/2] export command allocation and freeing functions independently
 of the host
Date: Thu, 13 Mar 2008 19:42:59 +0200
Message-ID: <47D967A3.3070106@panasas.com>
References: <1205427224.2893.23.camel@localhost.localdomain>	 <47D95EAC.2020301@panasas.com> <1205429708.2893.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:52533 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbYCMRnX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Mar 2008 13:43:23 -0400
In-Reply-To: <1205429708.2893.30.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andi Kleen <andi@firstfloor.org>

On Thu, Mar 13 2008 at 19:35 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Thu, 2008-03-13 at 19:04 +0200, Boaz Harrosh wrote:
>> Both me and Andi Kleen have audited all ISA drivers and found that none of them
>> use scsi_cmnd->cmnd or any other scsi_cmnd member for DMA. (Now that sense_buffer
>> is not a part of it). Should we not also kill the two pools and simplify the code
>> allot. This can be done now independently of the removal of unchecked_isa_dma?
> 
> Sure, but it's not logically part of this patch.
> 
> James
> 

You are right, but I was hoping for a removal patch previous to this one.
Well OK, sorry, I will need to rebase anyway.

Boaz

