From: Brian King <brking@us.ibm.com>
Subject: Re: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600 aacraidPERC
 3/Di Container goes offline
Date: Wed, 24 Nov 2004 08:58:59 -0600
Message-ID: <41A4A1B3.5070106@us.ibm.com>
References: <60807403EABEB443939A5A7AA8A7458B694FA8@otce2k01.adaptec.com> <20041124130904.GA12830@infradead.org>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:58248 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S262705AbUKXPCV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Nov 2004 10:02:21 -0500
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.132])
	by zeus.kernel.org (8.12.11/8.11.6) with ESMTP id iAOF293D014060
	for <linux-scsi@vger.kernel.org>; Wed, 24 Nov 2004 07:02:10 -0800
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e34.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id iAOEx1DP398478
	for <linux-scsi@vger.kernel.org>; Wed, 24 Nov 2004 09:59:01 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iAOEx1NM426352
	for <linux-scsi@vger.kernel.org>; Wed, 24 Nov 2004 07:59:01 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id iAOEx0R0026705
	for <linux-scsi@vger.kernel.org>; Wed, 24 Nov 2004 07:59:01 -0700
In-Reply-To: <20041124130904.GA12830@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Ryan Anderson <ryan@autoweb.net>, linux-scsi@vger.kernel.org



Christoph Hellwig wrote:
> On Wed, Nov 24, 2004 at 07:59:04AM -0500, Salyzyn, Mark wrote:
> 
>>I dropped Andrew Morton from the direct mail recipients.
>>
>>Thanks, made the change in my branch of the code. This adjustment will
>>probably never be submitted to MarkH since I use it only for debugging
>>purposes. However, would it be nice if the global scsi timeout could be
>>`user' adjustable?
>>
>>Not that I advocate it as readily accessible, since any storage device
>>that takes longer than ten seconds is in `trouble', and any timeout
>>longer than two minutes will no doubt cause servers to go offline on the
>>internet. Its purpose is only for troubleshooting.
> 
> 
> Yes, it would probably be nice to have a writeable timeout attribute for
> the scsi device.  Care to submit a patch?

This already exists today.

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

