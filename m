From: "Steven J. Hill" <sjhill@realitydiluted.com>
Subject: Re: [PATCH] 2.6.2, Partition support for SCSI CDROM...
Date: Sun, 22 Feb 2004 22:07:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40396E8F.4050307@realitydiluted.com>
References: <40396134.6030906@realitydiluted.com> <20040222190047.01f6f024.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eth13.com-link.com ([208.242.241.164]:43149 "EHLO
	real.realitydiluted.com") by vger.kernel.org with ESMTP
	id S261191AbUBWDIC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Feb 2004 22:08:02 -0500
In-Reply-To: <20040222190047.01f6f024.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Andrew Morton wrote:
> 
>>+config BLK_DEV_SR_PARTITIONS
>>+config BLK_DEV_SR_PARTITIONS_PER_DEVICE
> 
> 
> Do we actually need these config options?  Why not hardwire it to some
> reasonable upper bound and be done with it?
>
I have no problem hardwiring the number of partitions, but the
BLK_DEV_SR_PARTITIONS should still be an option to allow the
user to decided if they want partitioning support for their
SCSI CDROMs. Or are you suggesting that from now on partitions
will be supported by default?

> Why is this ifdef needed?
> 
Indeed, it is pointless.

-Steve
