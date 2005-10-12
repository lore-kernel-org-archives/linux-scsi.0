From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: scsi_eh: BUG in __schedule (was Re: Trouble installing 1394...)
Date: Wed, 12 Oct 2005 08:49:55 +0200
Message-ID: <434CB213.7040101@s5r6.in-berlin.de>
References: <20051011163832.49397.qmail@web54611.mail.yahoo.com>	 <5bdc1c8b0510110943reb9c49fu8428f6d4f67d5d75@mail.gmail.com>	 <434C2D25.3050403@s5r6.in-berlin.de>	 <5bdc1c8b0510111609y1309484au7893f4c154922af@mail.gmail.com>	 <434C5848.4010107@s5r6.in-berlin.de> <5bdc1c8b0510111831l4782c6a1q3a00bada519080ab@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:17100 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932383AbVJLGus (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Oct 2005 02:50:48 -0400
Received: from [192.168.0.41] ([62.180.98.151])
	(authenticated bits=0)
	by einhorn.in-berlin.de (8.12.10/8.12.10/Debian-4) with ESMTP id j9C6ogAp005422
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2005 08:50:45 +0200
In-Reply-To: <5bdc1c8b0510111831l4782c6a1q3a00bada519080ab@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

FYI,

Mark Knecht wrote to linux1394-user:
> On 10/11/05, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>>I gather from another post of yours that you got this from 2.6.14-rc4,
>>right?
> 
> 2.6.14-rc4-rt1. That adds Ingo's real time patches.
[...]
> I haven't seen the error again today. I've reooted a couple of
> times, but with slightly different kernels. (With and without latency
> tracing enabled.)
> 
>>I cc'd linux-scsi because that is where scsi_eh's authors are.
> 
> I removed it from this response as I'm not subscribed and I don't
> thinkI'm adding much here.
> 
> thanks for looking.
> 
> Cheers,
> Mark

-- 
Stefan Richter
-=====-=-=-= =-=- -==--
http://arcgraph.de/sr/
