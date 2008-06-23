From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/4] SCSI multibyte accessors
Date: Mon, 23 Jun 2008 10:32:34 -0500
Message-ID: <1214235154.3310.1.camel@localhost.localdomain>
References: <20080623151525.GE4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55324 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755762AbYFWPcj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2008 11:32:39 -0400
In-Reply-To: <20080623151525.GE4392@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Mon, 2008-06-23 at 09:15 -0600, Matthew Wilcox wrote:
> Introduce scsi_{get,put}_u{16,24,32}
> 
> The u16 and u32 variants are just aliases for be16 and be32 unaligned
> accessors.  u24 is open-coded byte accessors as the meaning of a
> byteswapped u24 quantity isn't entirely unambiguous, but we know what
> we want to accomplish with scsi_get_u24.
> 
> Also remove scsi_to_u32 and change its only user to scsi_get_u32().

If we're just doing this in the abstract, then we need a u64 as well for
things like port addresses.

Thanks,

James


