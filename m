From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH] Fixup vpd page length calculation
Date: Thu, 20 Mar 2014 13:37:49 +0000
Message-ID: <1395322669.2244.6.camel@dabdike.int.hansenpartnership.com>
References: <1395299964-56537-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:33302 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758109AbaCTNhv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Mar 2014 09:37:51 -0400
In-Reply-To: <1395299964-56537-1-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <4F214FE236F14D4A86D29EAEE3E2FB93@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2014-03-20 at 08:19 +0100, Hannes Reinecke wrote:
> The VPD page length parameter is not only used for the length,
> but also to hold any error code. So it needs to be moved to an
> integer.
> And we should be resetting the default VPD page length after
> each iteration so that we do not allocate overly large buffers.

This is pretty difficult to apply, since three patches are affected.  I
think I got it right (please check), but next time, I'd prefer the fixed
patches.

Thanks,

James

