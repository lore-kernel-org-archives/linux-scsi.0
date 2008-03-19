From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: scsi build breakage
Date: Wed, 19 Mar 2008 10:01:44 -0500
Message-ID: <1205938904.11527.5.camel@localhost.localdomain>
References: <20080319180528.0ebcabe7.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52636 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753043AbYCSTYr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 15:24:47 -0400
In-Reply-To: <20080319180528.0ebcabe7.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, linux-next@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2008-03-19 at 18:05 +1100, Stephen Rothwell wrote:
> I need the following patch to make various powerpc configs build.
> sg_copy_buffer is introduced by commit
> d9c3ddd20a2a1fca9655937d4fc636fcb8e9f59e ("[SCSI] block: add sg buffer
> copy helper functions") in the scsi/master branch included into
> yesterday's (and today's) linux-next tree.
> 
> I have applied this patch to today's linux-next tree.

Tomo already redid his tree with a fix for this yesterday ... since it
involves unwinding and redoing 10 patches, I'm just being lazy.

James


