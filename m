From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: Nero 4 Linux applications broken in 4.12
Date: Wed, 5 Jul 2017 14:09:27 +0200
Message-ID: <20170705120927.GG4076@linux-x5ow.site>
References: <460fefb4-d002-6989-0c90-63ea0e209fc3@googlemail.com>
 <20170705073928.GA4076@linux-x5ow.site>
 <9c58bac7-ddf4-3e47-b729-76e595804836@googlemail.com>
 <20170705084447.GD4076@linux-x5ow.site>
 <20170705084810.GE4076@linux-x5ow.site>
 <d92e31ed-db7f-aa4b-5dfd-3f6df4a49ea9@googlemail.com>
 <20170705115235.GF4076@linux-x5ow.site>
 <3790b5ad-c02f-6406-173b-f2a0563f642b@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36655 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751637AbdGEMJ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 Jul 2017 08:09:29 -0400
Content-Disposition: inline
In-Reply-To: <3790b5ad-c02f-6406-173b-f2a0563f642b@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Clayton <chris2553@googlemail.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Jul 05, 2017 at 01:05:46PM +0100, Chris Clayton wrote:
> Yes, I get:
> 
> [chris:~/rpm/build]$ su -c "./nerotest /dev/sg0"
> Password:
> write: Invalid argument
> FAIL

Awesome, thanks for confirming.

I'll work on it locally now and hopefully send you something to test soon.

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
