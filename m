From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: Nero 4 Linux applications broken in 4.12
Date: Wed, 5 Jul 2017 10:44:47 +0200
Message-ID: <20170705084447.GD4076@linux-x5ow.site>
References: <460fefb4-d002-6989-0c90-63ea0e209fc3@googlemail.com>
 <20170705073928.GA4076@linux-x5ow.site>
 <9c58bac7-ddf4-3e47-b729-76e595804836@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44182 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751651AbdGEIot (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 Jul 2017 04:44:49 -0400
Content-Disposition: inline
In-Reply-To: <9c58bac7-ddf4-3e47-b729-76e595804836@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Clayton <chris2553@googlemail.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Jul 05, 2017 at 08:57:54AM +0100, Chris Clayton wrote:
> Thanks for the reply, Johannes.
> The strace log for 4.12.0 is attached.

Thanks Chris.

Can I have a known good version as well? The counterpart to this snippet would
be great:

open("/dev/sg0", O_RDWR)                = 6
ioctl(6, SG_SET_RESERVED_SIZE, [131072]) = 0
ioctl(6, SG_SET_TIMEOUT, [10800000])    = 0
write(6, "\0\0\0\0H\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 42) = -1 EINVAL (Invalid argument)


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
