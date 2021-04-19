Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C3F0C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 15:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 482B26127C
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 15:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239042AbhDSPGu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 11:06:50 -0400
Received: from mailout.easymail.ca ([64.68.200.34]:53830 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238693AbhDSPGu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 11:06:50 -0400
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id C75B4C2899;
        Mon, 19 Apr 2021 15:06:19 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo04-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo04-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gFNAWWdJVtxJ; Mon, 19 Apr 2021 15:06:19 +0000 (UTC)
Received: from mail.gonehiking.org (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        by mailout.easymail.ca (Postfix) with ESMTPA id 4C499C2968;
        Mon, 19 Apr 2021 15:06:10 +0000 (UTC)
Received: from [192.168.1.4] (internal [192.168.1.4])
        by mail.gonehiking.org (Postfix) with ESMTP id 80A183EF41;
        Mon, 19 Apr 2021 09:06:09 -0600 (MDT)
Subject: Re: [PATCH 0/5] Bring the BusLogic host bus adapter driver up to
 Y2021
To:     Ondrej Zary <linux@zary.sk>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
 <a099f7f8-9601-fd1c-03a4-93587e7276e6@gonehiking.org>
 <alpine.DEB.2.21.2104162157360.44318@angie.orcam.me.uk>
 <202104182221.21533.linux@zary.sk>
From:   Khalid Aziz <khalid@gonehiking.org>
Message-ID: <e3fe98a2-c480-e9bf-67b3-7f51b87975bd@gonehiking.org>
Date:   Mon, 19 Apr 2021 09:06:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <202104182221.21533.linux@zary.sk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/18/21 2:21 PM, Ondrej Zary wrote:
> On Friday 16 April 2021 23:25:18 Maciej W. Rozycki wrote:
>> On Fri, 16 Apr 2021, Khalid Aziz wrote:
>>
>>>>  Sadly I didn't get to these resources while they were still there, and 
>>>> neither did archive.org, and now they not appear available from anywhere 
>>>> online.  I'm sure Leonard had this all, but, alas, he is long gone too.
>>>
>>> These documents were all gone by the time I started working on this
>>> driver in 2013.
>>
>>  According to my e-mail archives I got my BT-958 directly from Mylex brand 
>> new as KT-958 back in early 1998 (the rest of the system is a bit older).  
>> It wasn't up until 2003 when I was caught by the issue with the LOG SENSE 
>> command that I got interested in the programming details of the adapter.  
>>
>>  At that time Mylex was in flux already, having been bought by LSI shortly 
>> before.  Support advised me what was there at Leonard's www.dandelion.com 
>> site was all that was available (I have a personal copy of the site) and 
>> they would suggest to switch to their current products.  So it was too 
>> late already ten years before you got at the driver.
>>
>>  I'll yet double-check the contents of the KT-958 kit which I have kept, 
>> but if there was any technical documentation supplied there on a CD (which 
>> I doubt), I would have surely discovered it earlier.  It's away along with 
>> the server, remotely managed, ~160km/100mi from here, so it'll be some 
>> time before I get at it though.
>>
>>  Still, maybe one of the SCSI old-timers has that stuff stashed somewhere.  
>> I have plenty of technical documentation going back to early to mid 1990s 
>> (some in the hard copy form), not necessarily readily available nowadays. 
>> Sadly lots of such stuff goes offline or is completely lost to the mist of 
>> time.
>>
>>   Maciej
>>
> 
> Found the 3000763 document here:
> https://doc.lagout.org/science/0_Computer Science/0_Computer History/old-hardware/buslogic/3000763_PCI_EISA_Wide_SCSI_Tech_Ref_Dec94.pdf
> 
> There's also 3002593 there:
> https://doc.lagout.org/science/0_Computer Science/0_Computer History/old-hardware/buslogic/
> 

Thanks!!!

--
Khalid
