From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: tgtd CPU 100% problem
Date: Tue, 11 Jul 2017 13:41:17 +0300
Message-ID: <105b04a5-7f07-2e66-f915-2aa7aa19f9ea@grimberg.me>
References: <CAGpjB9JaSU45qi-_-fz7sF5sd=aEbLuNy6LL5fE2Md6zxqcgQQ@mail.gmail.com>
 <304976c9-88eb-7f4d-572c-5bd932208d52@grimberg.me>
 <CAGpjB9JXqEGfOO-DyFmoC6N_=dPOGhubM+-eZM=ZJ41DY44ytQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:32865 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754028AbdGKKlW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2017 06:41:22 -0400
In-Reply-To: <CAGpjB9JXqEGfOO-DyFmoC6N_=dPOGhubM+-eZM=ZJ41DY44ytQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?5p2O5pil?= <pickup112@gmail.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org


> Thanks very much for reply.
> I think it may be better to  assert failed to exit problem than run
> the endless loop after receivered DEVICE_REMOVAL event.
> Or we can sleep 5 ms to check if the conn->h.state is STATE_FULL.

Note that neither of the CC'd lists are the correct list
for stgt, you should correspond stgt@lists.wpkg.org

Regarding your observation, not sure why you think this is
happening, the work is queued once in 5 seconds and the loop
is finite.
