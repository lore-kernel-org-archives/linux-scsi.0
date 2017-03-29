From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/2] scsi: sas: flush destruct workqueue on device
 unregister
Date: Wed, 29 Mar 2017 14:51:17 +0200
Message-ID: <20170329125117.GF9183@linux-x5ow.site>
References: <cover.1490775958.git.jthumshirn@suse.de>
 <9580eaf323f5da17dcace9e32b22a1df4099961d.1490775958.git.jthumshirn@suse.de>
 <02778435-6c67-0ac9-2faa-03ebb7934477@huawei.com>
 <20170329112922.GB9183@linux-x5ow.site>
 <343ddf8b-70e0-32f8-6ab8-31479729f827@huawei.com>
 <20170329122630.GD9183@linux-x5ow.site>
 <CAMGffEnvL2f8rNxDSEp6NxmTs3V1Djq2Bavx8DsWGSwOcPJCXQ@mail.gmail.com>
 <20170329124754.GE9183@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48264 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932111AbdC2MvU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Mar 2017 08:51:20 -0400
Content-Disposition: inline
In-Reply-To: <20170329124754.GE9183@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>
Cc: John Garry <john.garry@huawei.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, Dan Williams <dan.j.williams@intel.com>, Hannes Reinecke <hare@suse.de>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>

On Wed, Mar 29, 2017 at 02:47:54PM +0200, Johannes Thumshirn wrote:
> > > John, mind giving that one a shot in your test setup as well?
> 
> Well, don't mind. It doesn't work in my test setup.
> 
> I'm back to the drawing board...

Please ignore my last mail, apparently it's a wise idea to do a git stash pop
after a git stash m)

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
