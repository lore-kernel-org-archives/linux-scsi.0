From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/5] qla2xxx: Add module param ql2xenablemsix
Date: Mon, 16 Oct 2017 08:57:37 +0200
Message-ID: <20171016065737.rtperbhkkrkrv2lp@linux-x5ow.site>
References: <20171011203650.23629-1-himanshu.madhani@cavium.com>
 <20171011203650.23629-2-himanshu.madhani@cavium.com>
 <20171012071957.gb2zobb7jqsuv4cq@linux-x5ow.site>
 <EE884809-2674-4801-A74A-2784467F4B09@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37887 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750942AbdJPG5j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Oct 2017 02:57:39 -0400
Content-Disposition: inline
In-Reply-To: <EE884809-2674-4801-A74A-2784467F4B09@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Oct 13, 2017 at 06:52:31PM +0000, Madhani, Himanshu wrote:
> Sorry this one slipped out of my sight. The reason I used "ql2xenablemsix" was because driver already
> had this parameter in code until few versions back where we removed it. Since existing user are familiar
> with this module parameter name, it would be easy to keep that same. 
> 
> Let me know if you are okay with the name or prefer new name instead? 

Heh I knew I had seen this parameter before, just couldn't find it anymore and
thought I must have been dreaming.

If it's only for reconstructing a previous stsate, it wouldn't make much sense
to rename it then.

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
