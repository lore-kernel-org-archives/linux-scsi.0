From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH 2/7] ipr: Handler ID memory allocation failure
Date: Mon, 03 Dec 2012 16:25:03 -0500
Message-ID: <20121203162503.Horde.Luneopir309QvRivP2oRXKA@imap.linux.ibm.com>
References: <20121126155534.352187900@linux.vnet.ibm.com>
 <20121126155632.125112047@linux.vnet.ibm.com>
 <1354289435.2259.18.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:58514 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab2LCVZe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Dec 2012 16:25:34 -0500
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Mon, 3 Dec 2012 14:25:33 -0700
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 81B373E4005E
	for <linux-scsi@vger.kernel.org>; Mon,  3 Dec 2012 14:25:27 -0700 (MST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id qB3LPAJL355146
	for <linux-scsi@vger.kernel.org>; Mon, 3 Dec 2012 14:25:10 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id qB3LP86a018160
	for <linux-scsi@vger.kernel.org>; Mon, 3 Dec 2012 14:25:09 -0700
In-Reply-To: <1354289435.2259.18.camel@dabdike.int.hansenpartnership.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, klebers@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Quoting James Bottomley <James.Bottomley@hansenpartnership.com>:

> On Mon, 2012-11-26 at 09:55 -0600, wenxiong@linux.vnet.ibm.com wrote:
>> plain text document attachment (fix_mem_alloc_fail)
>> Add code to handle memory allocation failures at module load time.
>>
>> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
>>
>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>
> The signoff chain on a lot of these patches is incorrect.
>
> This patch only has Brian's signoff and it needs yours because you sent
> it to me.  If it is really Brian's patch, it needs a
>
> From: Brian King <brking@linux.vnet.ibm.com>
>
> To get the authorship right.
>
> James

Hi James,

Thanks! I just re-sent the whole series with your suggestions.

Thanks,
Wendy

