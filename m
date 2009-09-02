From: Jonathan Nell <crtrn13@gmail.com>
Subject: Re: scsi traffic sniffing
Date: Wed, 2 Sep 2009 10:50:11 +0300
Message-ID: <48e952f40909020050n4135c37br9d927ab61c8bbd65@mail.gmail.com>
References: <48e952f40908312312w7765c2a1q3a4f022967735288@mail.gmail.com>
	 <48e952f40908312313u75e4d00cr3d934f1dbdd1cca9@mail.gmail.com>
	 <48e952f40908312313y372d5009mc0197dff49d3b778@mail.gmail.com>
	 <d364733c0909010340t57499a38y4c0bd949e5ba63a6@mail.gmail.com>
	 <d364733c0909012012s1c75434au6a2230e07af4241c@mail.gmail.com>
	 <48e952f40909012120y1d56bb6bha18330fa3266ed64@mail.gmail.com>
	 <d364733c0909012149sb5f780cia8acdc305535d376@mail.gmail.com>
	 <48e952f40909012348y4c86773am3096a32e3dc25218@mail.gmail.com>
	 <d364733c0909020021v4b6b3b61pa6a387836a7c927d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:63207 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbZIBHuK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 03:50:10 -0400
Received: by bwz19 with SMTP id 19so528951bwz.37
        for <linux-scsi@vger.kernel.org>; Wed, 02 Sep 2009 00:50:12 -0700 (PDT)
In-Reply-To: <d364733c0909020021v4b6b3b61pa6a387836a7c927d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xie Gang <xiegang112@gmail.com>
Cc: linux-scsi@vger.kernel.org

>> This is great - thanks! I assume I can just modify this slightly to
>> dump the data as well (and not just the cmd)?
> Of course, when you get the scsi cmd, you can get the request where
> data lives in.
> BTW, I don't use this driver under heavey load. There might be some
> performance issue. You can kick off the filter part.
>
> Thanks,
> Gang
>>

Hmmm kills my pc when loaded into my kernel (2.6.30)... What kernel
version did you last use this with?
