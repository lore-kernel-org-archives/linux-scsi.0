From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH 2/2] hpsa: destroy sas transport properties before
 scsi_host
Date: Wed, 11 Oct 2017 11:15:08 +0200
Message-ID: <1507713308.3223.9.camel@suse.de>
References: <20161121140429.12788-1-mwilck@suse.de>
         <20161121140429.12788-3-mwilck@suse.de>
         <20161121141441.rljdubw2rcmrl43v@linux-x5ow.site>
         <4993A297653ECB4581FA5C3C31323D1967210680@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49334 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752011AbdJKJPM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Oct 2017 05:15:12 -0400
In-Reply-To: <4993A297653ECB4581FA5C3C31323D1967210680@avsrvexchmbx2.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: dl-esc-Team ESD Storage Dev Support <esc-TeamESDStorageDevSupport@microsemi.com>, "iss_storagedev@hp.com" <iss_storagedev@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@odin.com" <JBottomley@odin.com>, "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>

On Tue, 2017-10-10 at 23:04 +0000, Don Brace wrote:
> Now that Hannes's patch  9441284fbc39610c0f9ec0ed118ff85d78352906
> has been applied, this patch corrects the stack trace issue.
> 
> Would you like to re-submit this patch or would you like me to send
> it up?
> I'll run some quick tests if you do decide to send it up. 
> If you want me to send it up, you will get the credit anyway.

>From my PoV, just go ahead and re-submit. It'll be faster than me
diving into this again.

Thanks,
Martin
