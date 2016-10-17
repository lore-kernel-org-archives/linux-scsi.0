From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: `rmmod mpt3sas` leads to backtraces 'fs/sysfs/group.c:237
 sysfs_remove_group+0xa0/0xb0'
Date: Mon, 17 Oct 2016 16:42:18 +0200
Message-ID: <20161017144218.r5wxpxk4oc4sdfe6@linux-x5ow.site>
References: <d24894f9-5943-a962-6614-9a199e563dd1@ojab.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48777 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933005AbcJQOmY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Oct 2016 10:42:24 -0400
Content-Disposition: inline
In-Reply-To: <d24894f9-5943-a962-6614-9a199e563dd1@ojab.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ojab <ojab@ojab.ru>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org

On Sun, Oct 16, 2016 at 02:33:28PM +0000, ojab wrote:
> Oh hai!
> 
> I have LSI SAS 9217-8i HBA and `rmmod mpt3sas` leads to multiple backtraces
> if any disks are connected to the HBA.
> Reproducible on vanilla 4.7.5/4.8.1/4.9-rc1 kernels (haven't tested on
> another versions).
> 
> Full output (4.9-rc1 kernel, 3*Seagate ST3000NM0023 drives are connected) is
> rather long and can be found here:
> https://gist.github.com/ojab/f21ff778a378e88b227a4253d683c6ca

Hi Ojab,

Do you have a known good kernel? If yes can you do a git bisect to see which
commit introduces this?

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
