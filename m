From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 20/28] drivers/message/fusion/linux_compat.h Removal of
 old code
Date: Mon, 25 Sep 2006 20:22:32 -0400
Message-ID: <451872C8.7000400@garzik.org>
References: <664A4EBB07F29743873A87CF62C26D7034FA42@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:34009 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751792AbWIZAWk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 20:22:40 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7034FA42@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: akpm@osdl.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, michal.k.k.piotrowski@gmail.com

Moore, Eric wrote:
> However pls don't remove this file from the tree.

Why?  That's against the general kernel policy...

As an example, when maintaining libata for 2.4 kernels as well as 2.6 
kernels, I had a libata-compat.h file, and always just patched the 
include into the kernel source at the same time I patched in the 
libata-compat.h contents.

	Jeff


