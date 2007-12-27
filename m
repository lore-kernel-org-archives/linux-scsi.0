From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH 1/3] cciss: export more attributes to sysfs (repost)
Date: Thu, 27 Dec 2007 23:55:43 +0000
Message-ID: <DEE40752C8AF224BB890E455C7B8E0FE15A296AD@G6W0268.americas.hpqcorp.net>
References: <20071214221744.GA32019@roadking.usa.hp.com>
 <20071221151647.ac8f864c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:29675 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbXL0X4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Dec 2007 18:56:54 -0500
In-Reply-To: <20071221151647.ac8f864c.akpm@linux-foundation.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "jens.axboe@oracle.com" <jens.axboe@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>
> Mike, what's going on?  I definitely told you last time I
> looked at this patch that it is a bug to call
> sysfs_remove_group() under spinlock, because
> sysfs_remove_group() takes sleeping locks.  Yet here it is again.
>
> Maybe you lost my email.  It is here:
> http://lkml.org/lkml/2007/11/20/77
>
>
> Also please see http://lkml.org/lkml/2007/11/20/79
>

Andrew,
My apologies. Obviously I did not read your email closely. When I return from vacation I will address these issues.

-- mikem
