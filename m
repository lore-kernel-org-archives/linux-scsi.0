From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: fc: check for rport presence in fc_block_scsi_eh
Date: Tue, 26 Sep 2017 08:55:14 +0200
Message-ID: <20170926065514.ila5o4oejc3c75w2@linux-x5ow.site>
References: <20170925120049.19689-1-jthumshirn@suse.de>
 <1506382146.2641.61.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34439 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935006AbdIZGzQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Sep 2017 02:55:16 -0400
Content-Disposition: inline
In-Reply-To: <1506382146.2641.61.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>

On Mon, Sep 25, 2017 at 11:29:07PM +0000, Bart Van Assche wrote:
> Did you perhaps intend to use WARN_ON_ONCE() instead of WARN_ON()?

Now that you're saying it. I'll send a v2.

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
