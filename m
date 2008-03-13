From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] export command allocation and freeing functions
	independently of the host
Date: Thu, 13 Mar 2008 12:35:08 -0500
Message-ID: <1205429708.2893.30.camel@localhost.localdomain>
References: <1205427224.2893.23.camel@localhost.localdomain>
	 <47D95EAC.2020301@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43666 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752137AbYCMRfN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Mar 2008 13:35:13 -0400
In-Reply-To: <47D95EAC.2020301@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andi Kleen <andi@firstfloor.org>

On Thu, 2008-03-13 at 19:04 +0200, Boaz Harrosh wrote:
> Both me and Andi Kleen have audited all ISA drivers and found that none of them
> use scsi_cmnd->cmnd or any other scsi_cmnd member for DMA. (Now that sense_buffer
> is not a part of it). Should we not also kill the two pools and simplify the code
> allot. This can be done now independently of the removal of unchecked_isa_dma?

Sure, but it's not logically part of this patch.

James


