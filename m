From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: PATCH 00/13] BNX2I: Patch set to fix various bug fixes
Date: Tue, 23 Nov 2010 18:16:29 -0600
Message-ID: <4CEC595D.8070602@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1290554972-16928-1-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58392 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab0KXAI0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2010 19:08:26 -0500
In-Reply-To: <1290554972-16928-1-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 11/23/2010 05:29 PM, Eddie Wai wrote:
> Hello,
>
> This patch set contains various bug fixes as categorized in the following:
> - scsi command handling (nop-ins, tmfs)
> - various connection clean up bug fixes
> In v3, the following patches are updated:
>    BNX2I: Fixed the remote TCP RST handling for the 570X (1g)
>
>> In v2, the following patches are modified based on Mike Christie's comments:
>>   BNX2I: Added mutex lock protection to conn_get_param (rm ret 0)
>>   BNX2I: Removed the dynamic registration of CNIC (trailing space)
>>
>
> In v3, these patches were removed pending better resolution:
>    BNX2I: Added feature to silently drop NOPOUT request
>>   BNX2I: Updated the handling of NETEVENTs to alleviate recovery
>>   BNX2I: Added code to handle the binding of an existing connection
>
> Your comments are grealy appreciated.  Please review, thanks.
>

Looks ok. Thanks

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
