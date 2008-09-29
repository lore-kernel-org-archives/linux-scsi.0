From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 02/17] aic7xxx: update .reg files
Date: Mon, 29 Sep 2008 17:21:09 -0500
Message-ID: <1222726869.3150.80.camel@localhost.localdomain>
References: <200809222156.m8MLuf0T032267@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49571 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754416AbYI2WVh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2008 18:21:37 -0400
In-Reply-To: <200809222156.m8MLuf0T032267@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, vda.linux@googlemail.com, hare@suse.de

On Mon, 2008-09-22 at 14:56 -0700, akpm@linux-foundation.org wrote:
> From: Denys Vlasenko <vda.linux@googlemail.com>
> 
> Update .reg files, marking unused registers with dont_generate_debug_code.
> Comment explains how to use it.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Hannes, can you inspect, test and ack these aic7xxx/79xx changes,
please?  They're pretty big, I'm afraid.

Thanks,

James


