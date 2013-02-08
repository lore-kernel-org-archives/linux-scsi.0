From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: [LSF/MM TOPIC] Reducing the SRP initiator failover time
Date: Fri, 08 Feb 2013 12:38:46 +0100
Message-ID: <5114E3C6.9010900@profitbricks.com>
References: <510BC68A.90708@acm.org> <CAJZOPZJeCdkJ0xfK0kxic9jfz5A5ddw7TSWXe51yuO6bYTk4ag@mail.gmail.com> <BB97625FCF082447AC2B11418FF02044A6E9E9C5@MTLDAG01.mtl.com> <51142DE9.30900@mellanox.com> <5114C453.7010904@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:38127 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946284Ab3BHLit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2013 06:38:49 -0500
Received: by mail-bk0-f49.google.com with SMTP id w11so1639271bku.36
        for <linux-scsi@vger.kernel.org>; Fri, 08 Feb 2013 03:38:47 -0800 (PST)
In-Reply-To: <5114C453.7010904@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Vu Pham <vu@mellanox.com>, lsf-pc@lists.linux-foundation.org, linux-scsi <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, David Dillow <dillowda@ornl.gov>, Oren Duer <oren@mellanox.com>

On 08.02.2013 10:24, Sagi Grimberg wrote:
> On 2/8/2013 12:42 AM, Vu Pham wrote:
>> Hello Bart,
>>
>> Thank you for taking the initiative.
>> Mellanox think that this should be discussed. We'd be happy to attend.
>>
>> We also would like to discuss:
>> * How and how fast does SRP detect a path failure besides RC error?
>> * Role of srp_daemon, how often srp_daemon scan fabric for new/old
>> targets, how-to scale srp_daemon discovery, traps.
>>
>> -vu
> Hey Bart,
> 
> I agree with Vu that this issue should be discussed. We'd be happy to
> attend.
> 
> -- 
> Sagi

Wow, also thanks to Mellanox for spending resources on SRP as well! Last
year in June we came across a very different situation.

Cheers,
Sebastian and the ProfitBricks storage team
