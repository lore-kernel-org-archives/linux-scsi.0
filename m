From: Yathindra <ydev@cs.utah.edu>
Subject: Re: Simulating faulty disk
Date: Thu, 20 Oct 2011 01:30:30 -0600
Message-ID: <4E9FCE16.4070106@cs.utah.edu>
References: <4E9F9321.8090704@cs.utah.edu> <20111020044734.GC15211@atlantis.cc.ndsu.nodak.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-svr1.cs.utah.edu ([155.98.64.241]:53139 "EHLO
	mail-svr1.cs.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab1JTHah (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2011 03:30:37 -0400
In-Reply-To: <20111020044734.GC15211@atlantis.cc.ndsu.nodak.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Mesich <bryan.mesich@ndsu.edu>
Cc: linux-scsi@vger.kernel.org

Hi Bryan,

I saw this too but it does not have features to delay the commands. And 
it works only at the file level.

I thought about scsi_debug driver but it seems to able to inject medium 
errors on sector 0x1234 only.
I'm not sure why that limitation exists though.

Thanks,
Yathi
On 10/19/2011 10:47 PM, Bryan Mesich wrote:
> On Wed, Oct 19, 2011 at 09:18:57PM -0600, Yathindra wrote:
>> Hi,
>>
>> I'm trying to simulate a faulty disk behavior on linux. Basically, I
>> want to inject various disk failure patterns
>> such as medium errors, unresponsive disk etc.
>>
>> What is the best way to go about it. I heard about scsi_debug driver but
>> it can only simulate medium
>> errors on fixed sector 0x1234. Also, scsi fault injection using
>> Systemtap seems to be a user space tool
>> limited to files.
>>
>> Any suggestions is greatly appreciated.
> I saw this go by the linux-scsi list a while back thinking it
> might be useful sometime down the road:
>
> http://lwn.net/Articles/265187/
>
> I think the project is hosted on sourceforge.net at the following
> URL:
>
> http://scsifaultinjtst.sourceforge.net/
>
> I had also read through part of a paper that was co-authored by
> the same person (from linux symposium 2008):
>
> http://www.linuxsymposium.org/archives/OLS/Reprints-2008/tanaka-reprint.pdf
>
> Doesn't look like there has been much activity since 2009, but it
> looks like it has the functionality you need.
>
> Bryan
>
>> Thanks,
>> Yathi

