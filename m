From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 4/4] scsi_transport_sas: switch to bsg-lib for SMP
 passthrough
Date: Tue, 29 Aug 2017 13:50:48 +0200
Message-ID: <20170829115048.GD9310@linux-x5ow.site>
References: <20170825153741.5091-1-hch@lst.de>
 <20170825153741.5091-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55835 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751241AbdH2Luv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Aug 2017 07:50:51 -0400
Content-Disposition: inline
In-Reply-To: <20170825153741.5091-5-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Chaitra Basappa <chaitra.basappa@broadcom.com>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

The scsi_transport_sas.c part looks good, I have a nearly identical version
(different remove part due to missing patch 1 of your series). For the other
parts I can't tell. 

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
