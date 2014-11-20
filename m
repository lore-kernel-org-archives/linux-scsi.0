From: merez@codeaurora.org
Subject: Re: [PATCH 0/2] UFS driver fixes for v3.18
Date: Thu, 20 Nov 2014 11:45:45 -0000
Message-ID: <0142d978ba393fab5d3c60847c99c4c4.squirrel@www.codeaurora.org>
References: <1416319366-11539-1-git-send-email-akinobu.mita@gmail.com>
    <20141120064530.GA5928@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:50748 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaKTLpq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 06:45:46 -0500
In-Reply-To: <20141120064530.GA5928@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <jbottomley@parallels.com>

Hi Chris and Mita,

We will review and test the below patches early next week.

Thanks,
Maya
> On Tue, Nov 18, 2014 at 11:02:44PM +0900, Akinobu Mita wrote:
>> This patch series includes two fixes for UFS driver.
>>
>> The first patch already got reviewed and it was a part of Dolev's
>> various
>> fixes for UFS-PM series
>> (http://marc.info/?l=linux-scsi&m=141405993104015),
>> but they are not merged scsi-queue yet.  So this series also includes
>> it.
>
> Actually that series is missing reviews for this and mother other
> patches.
>
> Can the UFS community please start reviewing each others patches?
> Thanks!
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Maya Erez
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
Collaborative Project

