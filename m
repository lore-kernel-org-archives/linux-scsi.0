From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCHv2] iscsi_ibft: Add prefix-len attr and display netmask
Date: Mon, 29 Feb 2016 13:25:25 -0800
Message-ID: <56D4B745.3050705@suse.com>
References: <cover.1456423714.git.lduncan@suse.com>
 <21ae62f67edf39ab09f6c5aa842b89fd7d6e1dc6.1456423714.git.lduncan@suse.com>
 <56D491BE.5010705@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbcB2V2z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Feb 2016 16:28:55 -0500
In-Reply-To: <56D491BE.5010705@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org
Cc: hare@suse.de, konrad@kernel.org

On 02/29/2016 10:45 AM, Mike Christie wrote:
> On 02/25/2016 12:15 PM, Lee Duncan wrote:
>> From: Hannes Reinecke <hare@suse.de>
>>
>> The iBFT table only specifies a prefix length, not a netmask.
>> And the netmask is pretty much pointless for IPv6.
>> So introduce a new attribute 'prefix-len' and display the
>> netmask attribute only for IPv4 addresses.
> 
> The code looks ok to me, but I think this ipv4 comment was left over
> from the last posting since it conflicts with the comment below about
> always displaying it. Maybe it can just be edited when the patch is
> merged to avoid having to resend again. If so,
> 
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
> 
> ...

Since there are no other comments, I will resubmit it with the comment
fixed.
-- 
Lee Duncan
