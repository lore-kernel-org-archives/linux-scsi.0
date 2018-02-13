From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] qla2xxx: Fix NULL pointer crash due to active timer for
 ABTS
Date: Tue, 13 Feb 2018 11:38:47 +0100
Message-ID: <1518518327.3592.6.camel@suse.de>
References: <20180212182814.4541-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58062 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933865AbeBMKit (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Feb 2018 05:38:49 -0500
In-Reply-To: <20180212182814.4541-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

Thanks Himanshu,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

Do you happen to know which commit it actually fixes?

-- 
Johannes Thumshirn                                          Storage
jthu
mshirn@suse.de                                +49 911 74053 689
SUSE
LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane
Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38
9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
