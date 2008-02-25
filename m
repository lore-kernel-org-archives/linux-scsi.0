From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [1/22] Add new sense_buffer_mask host template field
Date: Mon, 25 Feb 2008 06:48:28 -0800
Message-ID: <1203950908.3254.18.camel@localhost.localdomain>
References: <200802251235.889863872@firstfloor.org>
	 <20080224233513.F083B1B4183@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34940 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925AbYBYOsh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 09:48:37 -0500
In-Reply-To: <20080224233513.F083B1B4183@basil.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2008-02-25 at 00:35 +0100, Andi Kleen wrote:
> sense buffers are something that still needs to be explicitely 
> bounced in the scsi layer. Instead of using the global unchecked_isa_dma
> flag define a special fine grained mask for this.
> 
> I decided to use a full dma mask because that is most useful for some future
> infrastructure work I'm doing.

Why do we need a separate mask?  Why can't we just use the device
dma_mask?

James


