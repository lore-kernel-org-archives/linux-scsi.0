From: Lee Jones <lee.jones@canonical.com>
Subject: Re: Blank DVD is not detected / cannot burn
Date: Tue, 14 Sep 2010 15:47:54 +0100
Message-ID: <4C8F8B1A.9050106@canonical.com>
References: <4C8F5C3E.80909@canonical.com>	 <1284466724.20409.8.camel@mulgrave.site>  <4C8F6C2D.4070200@canonical.com> <1284468019.20409.14.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:49632 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab0INOry (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2010 10:47:54 -0400
In-Reply-To: <1284468019.20409.14.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

>> The same results have been seen in 2.6.32 and 2.6.35.
> 
> OK, I'd still lay better odds on a burner program problem ... but since
> it's so old, a bisection is likely needed.  Which kernel actually
> worked?

Rather than provide you with little pieces of information at a time, all
the information I have been given is in this bug report:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/613214
