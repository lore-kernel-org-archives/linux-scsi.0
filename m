From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 3/4] scsi: increase upper limit for max_sectors
Date: Fri, 30 May 2014 00:04:37 +0900
Message-ID: <CAC5umygh2a28Wu5mWr5-zqbxpV3Wi2D3aZZgkgYNZJvLbLgAbA@mail.gmail.com>
References: <1401021816-10423-1-git-send-email-akinobu.mita@gmail.com>
	<1401021816-10423-4-git-send-email-akinobu.mita@gmail.com>
	<94D0CD8314A33A4D9D801C0FE68B402958ABC354@G4W3296.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:52443 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbaE2PEi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 11:04:38 -0400
Received: by mail-lb0-f179.google.com with SMTP id c11so263838lbj.38
        for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 08:04:37 -0700 (PDT)
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958ABC354@G4W3296.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

2014-05-29 1:18 GMT+09:00 Elliott, Robert (Server Storage) <Elliott@hp.com>:
>
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Akinobu Mita
>> Sent: Sunday, 25 May, 2014 7:44 AM
>> To: linux-scsi@vger.kernel.org
>> Cc: Akinobu Mita; Jens Axboe; James E.J. Bottomley; Douglas Gilbert
>> Subject: [PATCH 3/4] scsi: increase upper limit for max_sectors
>>
> ...
>> -     } else if (sdp->use_16_for_rw) {
>> +     } else if ((this_count > 0xffff) || sdp->use_16_for_rw) {
>
> Suggestion: reorder those so the unlikely case of a huge
> this_count is on the right side of the || operator.

No problem.  I'll make this change in the next version.
Thanks for your suggestion.
