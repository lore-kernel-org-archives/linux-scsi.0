From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Re: [PATCH] bnx2fc: setup em for npiv port
Date: Thu, 28 Apr 2011 15:32:57 -0700
Message-ID: <4DB9EB19.3010008@broadcom.com>
References: <20110315231329.13280.54456.stgit@vifc.jf.intel.com>
 <1304029125.10064.36.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
 <1304029536.2598.41.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4046 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab1D1WdJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2011 18:33:09 -0400
In-Reply-To: <1304029536.2598.41.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Vasu Dev <vasu.dev@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 4/28/2011 3:25 PM, James Bottomley wrote:
> On Thu, 2011-04-28 at 15:18 -0700, Bhanu Gollapudi wrote:
>> On Tue, 2011-03-15 at 16:13 -0700, Vasu Dev wrote:
>>> Use fc_exch_mgr_list_clone to setup em for npiv port.
>>>
>>> Also remove redundant vport and lport initializations.
>>>
>>> Signed-off-by: Vasu Dev<vasu.dev@intel.com>
>>
>> Acked-by: Bhanu Prakash Gollapudi<bprakash@broadcom.com>
>
> This patch hasn't ever been submitted as far as I can tell.

Probably because Vasu submitted only to devel@open-fcoe.org. Should I 
re-submit the patch to linux-scsi list?

Thanks,
Bhanu

>
> James
>
>
>


