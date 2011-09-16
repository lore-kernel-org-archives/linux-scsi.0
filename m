From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 3/4] drivers/scsi/mpt2sas/mpt2sas_transport.c: take size
 of pointed value, not pointer
Date: Fri, 16 Sep 2011 09:32:16 -0700
Message-ID: <1316190736.19950.2.camel@Joe-Laptop>
References: <1316156255-19509-3-git-send-email-julia@diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:53541 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750777Ab1IPQcR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2011 12:32:17 -0400
In-Reply-To: <1316156255-19509-3-git-send-email-julia@diku.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, kernel-janitors@vger.kernel.org, Kashyap Desai <kashyap.desai@lsi.com>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 08:57 +0200, Julia Lawall wrote:
> Sizeof a pointer-typed expression returns the size of the pointer, not that
> of the pointed data.

Hi Julia.

I submitted the same thing in May.
I hope it takes this time.

https://lkml.org/lkml/2011/5/9/31


