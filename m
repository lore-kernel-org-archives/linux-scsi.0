From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 4/6] qla2xxx: Send FC4 type NVMe to the management server
Date: Wed, 21 Jun 2017 09:07:04 +0200
Message-ID: <20170621070704.GA4131@linux-x5ow.site>
References: <20170616224744.3681-1-himanshu.madhani@cavium.com>
 <20170616224744.3681-5-himanshu.madhani@cavium.com>
 <20170619100641.GB19417@linux-x5ow.site>
 <032AF3DB-A17D-418E-A505-724D51CB7391@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36444 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751149AbdFUHHG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jun 2017 03:07:06 -0400
Content-Disposition: inline
In-Reply-To: <032AF3DB-A17D-418E-A505-724D51CB7391@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Trapp, Darren" <Darren.Trapp@cavium.com>

On Tue, Jun 20, 2017 at 10:13:04PM +0000, Madhani, Himanshu wrote:
> Somehow in the actual code this does not look like issue. (i.e. correct indentation is seen) 
> i am not sure why in patch view its showing one space off.

Strange. I guess we'll have to live with it then.

Ah and I think you forgot to Cc the linux-nvme [1] list on your submission. It
would be good to have it on linux-nvme as well as on linux-scsi so Sagi,
Christoph and Keith see it as well.

Byte,
	Johannes

[1] linux-nvme@lists.infradead.org
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
