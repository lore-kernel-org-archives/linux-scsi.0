From: Luigi Tarenga <luigi.tarenga@gmail.com>
Subject: Re: targetcli do not show iscsi
Date: Tue, 30 Sep 2014 17:52:34 +0200
Message-ID: <542AD1C2.8070105@gmail.com>
References: <542A6F44.3070802@gmail.com> <542A7037.6050909@netiant.com> <542A722E.5030109@gmail.com> <542A73BE.2080501@netiant.com> <542A75F1.8070706@gmail.com> <542A77D6.4090109@netiant.com> <542A7ADD.3040804@gmail.com> <542A7BC9.2050708@netiant.com> <542ACA6C.104@redhat.com> <542ACDAE.3080307@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:44980 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaI3Pwd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 11:52:33 -0400
In-Reply-To: <542ACDAE.3080307@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Jerome Martin <jxm@netiant.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>


On 09/30/2014 05:35 PM, Luigi Tarenga wrote:
>
> On 09/30/2014 05:21 PM, Andy Grover wrote:
>> On 09/30/2014 02:45 AM, Jerome Martin wrote:
>>>
>>>
>>> On 09/30/2014 11:41 AM, Luigi Tarenga wrote:
>>>>
>>>> On 09/30/2014 11:28 AM, Jerome Martin wrote:
>>>>> Luigi,
>>>>>
>>>>> Out of curiosity, does it work as expected with the stock fedora
>>>>> packaged kernel ?
>>>>>
>>>>> Best,
>>>>> -- 
>>>>> Jerome
>>>>>
>>>>
>>>> didn't test that configuration and since I can't find module
>>>> iscsi_target_mod in stock
>>
>> iscsi is not a supported fabric on rhel/centos 6. Only FCoE uses LIO. 
>> scsi-target-utils (tgt) is the supported iscsi target on rhel6. rhel7 
>> uses LIO for both, as does Fedora.
>>
>> Regards -- Andy
>>
> Hi Andy,
> I see LIO is a technology preview on rhel 6 but I'm not looking for 
> official support, just play with it :)
> that said I have a custom kernel compiled from vanilla so if we 
> esclude some problem with
> udev or other userspace services only kernel modules and targetcli is 
> involved in this configuration.
> I hope someone that maintain this module have some time to help me to 
> get it running otherwise
> I will try to use scst  (actually I compiled and installed it but 
> still have to configure it).
>
> My final goal is to have a litttle lab that let me write an 
> integration module for my failover cluster
> manager ( https://code.google.com/p/back-to-work/ ). I need to 
> implement scsi fencing without
> destroying a production server connected to a real SAN :P
>
> Luigi

Maybe I misunderstood your statement. Are you saying that
the targetcli I'm using (fb16) does not support iscsi fabric?
In this case I will try to use the git version.

Luigi

