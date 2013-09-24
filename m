From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [PATCHv2 0/7] Limit overall SCSI EH runtime
Date: Tue, 24 Sep 2013 16:51:58 -0400
Message-ID: <5241FB6E.6010106@gmail.com>
References: <1372661455-122384-1-git-send-email-hare@suse.de> <1373488528.7420.55.camel@localhost.localdomain> <5201ECAD.7000703@cn.fujitsu.com> <521F4768.5010807@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:37730 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab3IXUwA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Sep 2013 16:52:00 -0400
Received: by mail-qa0-f52.google.com with SMTP id k4so2851186qaq.4
        for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2013 13:52:00 -0700 (PDT)
In-Reply-To: <521F4768.5010807@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Ren Mingxin <renmx@cn.fujitsu.com>, emilne@redhat.com, linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>

On 08/29/2013 09:06 AM, Hannes Reinecke wrote:
> Hi James,
>
> On 08/07/2013 08:43 AM, Ren Mingxin wrote:
>> Hi, James:
>>
>> On 07/11/2013 04:35 AM, Ewan Milne wrote:
>>> Looks good.  We have been testing this extensively.
>>>
>>> Acked-by: Ewan D. Milne<emilne@redhat.com>
>> Do you think this patchset can be applied? If so, When? Perhaps you
>> are waiting for someone's feedback?
>>
>> We've also tested and got the duration could be shortened from 6m26s
>> to 44s when 'eh_deadline' was set as 1s(the minimum value of timeout)
>> and 16M data were written(I/O processing time can be ignored - 0.7s).
>>
>> As Ewan said, this is efficient to fast failover policy for redundant
>> environments.
>>
>> Thanks,
>> Ren
> Any objections to this patchset?
> I have other patchsets pending (eg asynchronous command aborts)
> which are based on this one.
> So it would be good to have a status here.
>
> Cheers,
>
> Hannes

Any progress on this patchset? Seems to have gone dormant?

thanks!

Ric

