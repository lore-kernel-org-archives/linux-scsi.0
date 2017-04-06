From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] Make checking the scsi_device_get() return value
 mandatory
Date: Thu, 6 Apr 2017 10:25:49 +0200
Message-ID: <20170406082548.GB3768@linux-x5ow.site>
References: <4b49f610-4ae7-ac4c-5c93-920c034e964d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33531 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752913AbdDFIZy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 Apr 2017 04:25:54 -0400
Content-Disposition: inline
In-Reply-To: <4b49f610-4ae7-ac4c-5c93-920c034e964d@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Apr 05, 2017 at 09:52:50AM -0700, Bart Van Assche wrote:
> Now that all scsi_device_get() callers check the return value of this
> function, make checking that return value mandatory.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
