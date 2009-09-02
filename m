From: Xie Gang <xiegang112@gmail.com>
Subject: Re: scsi traffic sniffing
Date: Wed, 2 Sep 2009 15:21:20 +0800
Message-ID: <d364733c0909020021v4b6b3b61pa6a387836a7c927d@mail.gmail.com>
References: <48e952f40908312312w7765c2a1q3a4f022967735288@mail.gmail.com>
	 <48e952f40908312313u75e4d00cr3d934f1dbdd1cca9@mail.gmail.com>
	 <48e952f40908312313y372d5009mc0197dff49d3b778@mail.gmail.com>
	 <d364733c0909010340t57499a38y4c0bd949e5ba63a6@mail.gmail.com>
	 <d364733c0909012012s1c75434au6a2230e07af4241c@mail.gmail.com>
	 <48e952f40909012120y1d56bb6bha18330fa3266ed64@mail.gmail.com>
	 <d364733c0909012149sb5f780cia8acdc305535d376@mail.gmail.com>
	 <48e952f40909012348y4c86773am3096a32e3dc25218@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:40717 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbZIBHVT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 03:21:19 -0400
Received: by ewy2 with SMTP id 2so517974ewy.17
        for <linux-scsi@vger.kernel.org>; Wed, 02 Sep 2009 00:21:21 -0700 (PDT)
In-Reply-To: <48e952f40909012348y4c86773am3096a32e3dc25218@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Nell <crtrn13@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Sep 2, 2009 at 2:48 PM, Jonathan Nell<crtrn13@gmail.com> wrote:
>>>>
>>>> I developed a tool to dump all the SCSI cmds to SCSI device. The idea
>>>> is, every SCSI host controller driver should give the queue_command
>>>> fucntion. This is the entrance for SCSI request to SCSI host
>>>> controller driver. I replace this function with my own dump methord
>>>> and after dump, I restore this function.
>>>>
>>>> I do't know if it's what you need.
>>>
>>> That would be great! Could you send the code to me? How does your tool
>>> hook into queue_command?
>
>> The code could be found at
>> http://blog.chinaunix.net/u/15278/showart_1966962.html. You need do
>> some modification according your kernel.
>> It's very simple to hook the queue_command. I just backup the original
>> function pointer somewhere and after dump, I restore it. Pls refer the
>> code for detail.
>>
>
> This is great - thanks! I assume I can just modify this slightly to
> dump the data as well (and not just the cmd)?
Of course, when you get the scsi cmd, you can get the request where
data lives in.
BTW, I don't use this driver under heavey load. There might be some
performance issue. You can kick off the filter part.

Thanks,
Gang
>



-- 
Xie Gang
