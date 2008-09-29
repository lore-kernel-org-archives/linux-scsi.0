From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 09/17] ipr: use memory_read_from_buffer()
Date: Mon, 29 Sep 2008 17:24:05 -0500
Message-ID: <1222727045.3150.82.camel@localhost.localdomain>
References: <200809222156.m8MLulrK032288@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49591 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141AbYI2WYd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2008 18:24:33 -0400
In-Reply-To: <200809222156.m8MLulrK032288@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, akinobu.mita@gmail.com, brking@us.ibm.com

On Mon, 2008-09-22 at 14:56 -0700, akpm@linux-foundation.org wrote:
> From: Akinobu Mita <akinobu.mita@gmail.com>
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Brian King <brking@us.ibm.com>
> Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Brian,

Can I get an ack for this (or can you merge it into your patch set)?

Thanks,

James


