From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 21 Mar 2011 07:56:18 -0500
Message-ID: <4D874AF2.3090602@linux.vnet.ibm.com>
References: <20110307134033K.fujita.tomonori@lab.ntt.co.jp> <1299508803.12730.1.camel@mulgrave.site> <4D83C78D.5040908@linux.vnet.ibm.com> <20110321100909E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48303 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab1CUM4V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 08:56:21 -0400
Received: from d01dlp01.pok.ibm.com (d01dlp01.pok.ibm.com [9.56.224.56])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p2LCand6017051
	for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2011 08:36:49 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 3524938C803C
	for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2011 08:56:15 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p2LCuJM12707662
	for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2011 08:56:19 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p2LCuIdL011250
	for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2011 09:56:19 -0300
In-Reply-To: <20110321100909E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@suse.de, nab@linux-iscsi.org, linux-scsi@vger.kernel.org

On 03/20/2011 08:09 PM, FUJITA Tomonori wrote:
> Thanks for the testings,
> 
> On Fri, 18 Mar 2011 15:58:53 -0500
> Brian King <brking@linux.vnet.ibm.com> wrote:
> 
>> On 03/07/2011 08:40 AM, James Bottomley wrote:
>>> On Mon, 2011-03-07 at 13:41 +0900, FUJITA Tomonori wrote:
>>>> On Sat, 12 Feb 2011 14:27:26 -0600
>>>> James Bottomley <James.Bottomley@suse.de> wrote:
>>>>
>>>>>> Disregard my previous comment. It looks like current client should handle reservations
>>>>>> just fine without any further changes.
>>>>>
>>>>> So is that an ack for putting this in scsi-misc ... or did you want to
>>>>> do more testing first?
>>>>
>>>> Ping,
>>>>
>>>> Brian, James, can we merge this during the next merge window?
>>>
>>> I'm still waiting for an ack from Brian.
>>
>> Sorry for the delay... I've got this loaded in the lab and have managed to oops
>> a couple times. The first one was during shutdown, which I wasn't able to collect
>> any data for. The most recent occurred when a client was trying to login for the
>> first time:
> 
> You mean that the kernel crashes every time when a client logs in?

That is correct. This occurs whether or not there are any virtual disks defined. This
is occurring with current linus git head plus the three patches that were posted.

-Brian


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


