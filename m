From: Karen Xie <kxie@chelsio.com>
Subject: RE: [PATCH 0/4] cxgbi: driver update
Date: Mon, 4 May 2015 22:43:30 +0000
Message-ID: <1442C3287A121140B690F7F20F94463D8F157C@nice.asicdesigners.com>
References: <201504102057.t3AKv9xR028741@localhost6.localdomain6>,<552C268E.10001@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:4681 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbbEDWqH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2015 18:46:07 -0400
In-Reply-To: <552C268E.10001@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "hch@infradead.org" <hch@infradead.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>


On Monday, April 13, 2015 1:26 PM, Mike Christie wrote:
>
>> This patch set contains fixes and updates for the cxgbi drivers. It updates
>> the driver copyrights and versions, added logic to adjust the send/recv
>> window based on the link speed and the initial sequence number.
>>
>> Karen Xie (4):
>> cxgbi: use per-connection link-speed dependent send/recv windows
>> cxgbi: update copyright to 2015
>> cxgbi: update driver versions
>> cxgb4i: added setting of the initial sequence number
>>
>
> Looks ok to me.
>
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

Any chance this patch set would get merged soon? Thanks!