From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] bsg: SAS SMP pass-through documentation
Date: Thu, 11 Aug 2011 13:50:44 -0700
Message-ID: <20110811135044.ef369cec.rdunlap@xenotime.net>
References: <4E434E0E.40704@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:49771 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753652Ab1HKUuq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2011 16:50:46 -0400
In-Reply-To: <4E434E0E.40704@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Wed, 10 Aug 2011 23:35:42 -0400 Douglas Gilbert wrote:

> This is a patch against scsi-misc-2.6 .
> 
> ChangeLog:
>    - new documentation file for the bsg driver pass-through
>      being used to send SAS SMP functions
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

James usually merges Documentation/scsi/ patches, so I'll leave it for
him unless he wants me to merge it.

Thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
