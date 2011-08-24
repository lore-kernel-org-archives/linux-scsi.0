From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Re: [PATCH v2 00/18] bnx2fc version 1.0.5
Date: Wed, 24 Aug 2011 11:29:41 -0700
Message-ID: <4E554315.5020609@broadcom.com>
References: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
 <1314156445.4813.7.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4064 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab1HXS3w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2011 14:29:52 -0400
In-Reply-To: <1314156445.4813.7.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Michael Chan <mchan@broadcom.com>, "robert.w.love@intel.com" <robert.w.love@intel.com>, "devel@open-fcoe.org" <devel@open-fcoe.org>

On 8/23/2011 10:48 PM, James Bottomley wrote:
> On Thu, 2011-08-04 at 17:38 -0700, Bhanu Prakash Gollapudi wrote:
>> v2 submittal:
>> Minor changes to patch 5, 8 and patch 13.
>> Patch 5  - Removed unnecessary printk
>> Patch 8  - Added code to ignore netdev events other than UNREGISTER for vlan interface
>> patch 13 - Error handling fixed for tgt_init_err.
>> --------
>>
>> This patchset contains bnx2fc bug fixes.  Please note that patch 15 is
>> 'fcoe/libfcoe' patch, which moves LLD common code from fcoe driver to
>> fcoe_transport, to enable patch 16 and 17.
>
> So this is a nice mix of features and bug fixes ... what do I have to do
> exactly to persuade you to submit the two things separately ... so they
> can go through separate trees and be tagged for backport to stable if
> necessary?
>
> However, it's late and I'm tired, so I just put them in SCSI misc.  This
> means that if you can separate out the bug fixes, you can submit them to
> stable manually.
>
> James

James, in future, I'll make sure to submit enhancements and bug fixes in 
separate patchsets. For not, it is okay if they are merged to 3.2.

Thanks,
Bhanu
>


