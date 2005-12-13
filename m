From: Wang Zhenyu <zhenyu.z.wang@intel.com>
Subject: Re: [PATCH 0/8] iscsi update
Date: Tue, 13 Dec 2005 09:44:10 +0800
Message-ID: <20051213014409.GA14325@zhen-devel.sh.intel.com>
References: <1133327553.28356.36.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr20.intel.com ([134.134.136.19]:24979 "EHLO
	orsfmr005.jf.intel.com") by vger.kernel.org with ESMTP
	id S1751224AbVLMBoN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Dec 2005 20:44:13 -0500
Content-Disposition: inline
In-Reply-To: <1133327553.28356.36.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

On 2005.11.30 13:12:33 +0000, Mike Christie wrote:
> 
>    I get to be the patch monkey again so here is a iscsi update. The
>    following patches except 01 and 04 are bug fixes. Patch 01 and 04 begin
>    to add support for other interconnects like rdma. We are not sending
>    support for rdma at this time. Those two patches should be netlink and
>    sysfs values that are some what interesting for the code we have in
>    mainline. If someone has a problem with those patches the patchset can
>    live without them though (it will apply at a offset but be ok).
>    We know we are late for 2.6.15 and that those two patches do not qualify
>    for rc bugfixes so we understand if this gets queued to 2.6.16-rc1.
>    Patches were made against scsi-misc but apply to scsi-rc-fixes.

ping for this patchset? These patches except rdma bits are all important fixes
for iscsi_tcp. James, is there any problem with them to scsi-rc-fixes? 
I think it's good to be in 2.6.15, and that keeps mainline kernel update with
our svn version. 

thanks
