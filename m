From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [RFC] Simlify dif_verify routines and fixup fileio protection
 information code.
Date: Wed, 15 Apr 2015 13:07:11 +0300
Message-ID: <552E384F.3030203@dev.mellanox.co.il>
References: <1428945575-30839-1-git-send-email-sagig@mellanox.com>	<CAC5umygZ_qCu0x3RfTQs21R1Poa6A10FkhmGak7ccc2HvY4ROQ@mail.gmail.com>	<552D4C7B.9000402@dev.mellanox.co.il> <CAC5umyj9FsnumRhvNrzqE=Rtpy3O32SBw43ZP9M8H5B3htbRpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35825 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbbDOKHQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Apr 2015 06:07:16 -0400
Received: by widdi4 with SMTP id di4so147890842wid.0
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2015 03:07:15 -0700 (PDT)
In-Reply-To: <CAC5umyj9FsnumRhvNrzqE=Rtpy3O32SBw43ZP9M8H5B3htbRpw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>

On 4/15/2015 2:52 AM, Akinobu Mita wrote:

>>>
>>> Looks good...
>>>
>>> I'll test with these patches and check if the problems I met
>>> disappear.
>>
>>
>> Thanks Akinobu,
>>
>> Waiting to hear your verdict before sending a formal patchset.
>
> I hit a original bug in sbc_dif_verify() which is not introduced by
> your patch set, though.

What is this original bug?

>  Please consider to include attached patch.

I'll include it. thanks.

> I'm still seeing another problem and trying to find out a root cause,
> but it seems like it's caused by other change in -next.
>

care to elaborate?

Sagi.
