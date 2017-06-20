From: John Garry <john.garry@huawei.com>
Subject: Re: mptsas crash on expander hot-remove
Date: Tue, 20 Jun 2017 10:30:44 +0100
Message-ID: <29cd97b8-be66-cb7a-28c6-d7ed97cf40f0@huawei.com>
References: <20170616235708.GA19825@hangar16.net>
 <20170619082340.GC3752@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:8356 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751874AbdFTJbQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jun 2017 05:31:16 -0400
In-Reply-To: <20170619082340.GC3752@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Will Simoneau <simoneau@hangar16.net>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, tj@kernel.org, Dan Williams <dan.j.williams@intel.com>, Linuxarm <linuxarm@huawei.com>

On 19/06/2017 09:23, Johannes Thumshirn wrote:
> On Fri, Jun 16, 2017 at 07:57:08PM -0400, Will Simoneau wrote:
>> Is this is a known / obvious issue, or should I try to bisect it?
>

Out of curiousity, does this issue also occur when only the disk is 
hot-removed from the expander?

> This is a known issue with SAS (and FC) drivers, although no soulution exists
> to this point.
>
> 	Johannes
>
