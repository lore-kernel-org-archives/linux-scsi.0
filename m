From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/2] Fix sysfs recursive removal splats in isci
Date: Wed, 29 Mar 2017 11:23:08 -0400
Message-ID: <20170329152308.GA30385@htj.duckdns.org>
References: <cover.1490775958.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:33151 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752170AbdC2PXL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2017 11:23:11 -0400
Content-Disposition: inline
In-Reply-To: <cover.1490775958.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Dan Williams <dan.j.williams@intel.com>, John Garry <john.garry@huawei.com>, Jack Wang <jinpu.wang@profitbricks.com>, Hannes Reinecke <hare@suse.de>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>

Hello,

On Wed, Mar 29, 2017 at 11:41:07AM +0200, Johannes Thumshirn wrote:
> This series fixes a sysfs warning caused by isci not being able to cope with
> recursive sysfs path removals which are in place since commit bcdde7e
> ("sysfs: make __sysfs_remove_dir() recursive").

Thanks for fixing these.

> The mvsas, aic94xx and pm8001 and hisi_sas patches have been compile tested
> only hence they have no callstack of the affected path in their changelogs.
> 
> I'm not sure whether to mark this patches as stable or not. I tend to say no
> here, although we've seen complaints/bug reports on lkml and the scsi list.

Given that the failures aren't critical or all that common (only
happens on controller removal), I agree that not cc'ing stable is the
right call here.

Thanks.

-- 
tejun
