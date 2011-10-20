From: Yathindra <ydev@cs.utah.edu>
Subject: Re: Simulating faulty disk
Date: Thu, 20 Oct 2011 02:43:30 -0600
Message-ID: <4E9FDF32.6050305@cs.utah.edu>
References: <4E9F9321.8090704@cs.utah.edu> <20111020044734.GC15211@atlantis.cc.ndsu.nodak.edu> <4E9FCE16.4070106@cs.utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-svr1.cs.utah.edu ([155.98.64.241]:53941 "EHLO
	mail-svr1.cs.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab1JTIng (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2011 04:43:36 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail-svr1.cs.utah.edu (Postfix) with ESMTP id C13FA65011D
	for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2011 02:43:35 -0600 (MDT)
In-Reply-To: <4E9FCE16.4070106@cs.utah.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: ydev@cs.utah.edu

Hi,

Can anybody with experience in using scsi_debug driver tell me if it can
be used to inject medium errors on various file/disk blocks.

And also, can it delay commands so we can simulate an unresponsive disk.

Thanks,
Yathi
On 10/20/2011 1:30 AM, Yathindra wrote:
> Hi Bryan,
>
> I saw this too but it does not have features to delay the commands. 
> And it works only at the file level.
>
> I thought about scsi_debug driver but it seems to able to inject 
> medium errors on sector 0x1234 only.
> I'm not sure why that limitation exists though.
>
> Thanks,
> Yathi
> On 10/19/2011 10:47 PM, Bryan Mesich wrote:
>> On Wed, Oct 19, 2011 at 09:18:57PM -0600, Yathindra wrote:
>>> Hi,
>>>
>>> I'm trying to simulate a faulty disk behavior on linux. Basically, I
>>> want to inject various disk failure patterns
>>> such as medium errors, unresponsive disk etc.
>>>
>>> What is the best way to go about it. I heard about scsi_debug driver 
>>> but
>>> it can only simulate medium
>>> errors on fixed sector 0x1234. Also, scsi fault injection using
>>> Systemtap seems to be a user space tool
>>> limited to files.
>>>
>>> Any suggestions is greatly appreciated.
>> I saw this go by the linux-scsi list a while back thinking it
>> might be useful sometime down the road:
>>
>> http://lwn.net/Articles/265187/
>>
>> I think the project is hosted on sourceforge.net at the following
>> URL:
>>
>> http://scsifaultinjtst.sourceforge.net/
>>
>> I had also read through part of a paper that was co-authored by
>> the same person (from linux symposium 2008):
>>
>> http://www.linuxsymposium.org/archives/OLS/Reprints-2008/tanaka-reprint.pdf 
>>
>>
>> Doesn't look like there has been much activity since 2009, but it
>> looks like it has the functionality you need.
>>
>> Bryan
>>
>>> Thanks,
>>> Yathi
>

