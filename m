From: Luigi Tarenga <luigi.tarenga@gmail.com>
Subject: Re: targetcli do not show iscsi
Date: Tue, 30 Sep 2014 18:49:33 +0200
Message-ID: <542ADF1D.1020003@gmail.com>
References: <542A6F44.3070802@gmail.com> <542A7037.6050909@netiant.com> <542A722E.5030109@gmail.com> <542A73BE.2080501@netiant.com> <542A75F1.8070706@gmail.com> <542A77D6.4090109@netiant.com> <542A7ADD.3040804@gmail.com> <542A7BC9.2050708@netiant.com> <542ACA6C.104@redhat.com> <542ACDAE.3080307@gmail.com> <542AD1C2.8070105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:43951 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaI3Qtw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 12:49:52 -0400
In-Reply-To: <542AD1C2.8070105@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Jerome Martin <jxm@netiant.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>


>>> iscsi is not a supported fabric on rhel/centos 6. Only FCoE uses 
>>> LIO. scsi-target-utils (tgt) is the supported iscsi target on rhel6. 
>>> rhel7 uses LIO for both, as does Fedora.
>>>
>>> Regards -- Andy
>>>
>> Hi Andy,
>> I see LIO is a technology preview on rhel 6 but I'm not looking for 
>> official support, just play with it :)
>> that said I have a custom kernel compiled from vanilla so if we 
>> esclude some problem with
>> udev or other userspace services only kernel modules and targetcli is 
>> involved in this configuration.
>> I hope someone that maintain this module have some time to help me to 
>> get it running otherwise
>> I will try to use scst  (actually I compiled and installed it but 
>> still have to configure it).
>>
>> My final goal is to have a litttle lab that let me write an 
>> integration module for my failover cluster
>> manager ( https://code.google.com/p/back-to-work/ ). I need to 
>> implement scsi fencing without
>> destroying a production server connected to a real SAN :P
>>
>> Luigi
>
> Maybe I misunderstood your statement. Are you saying that
> the targetcli I'm using (fb16) does not support iscsi fabric?
> In this case I will try to use the git version.
>
> Luigi
>

got it working :D

# targetcli
targetcli shell version 2.1.fb37
Copyright 2011-2013 by Datera, Inc and others.
For help on commands, type 'help'.

/> ls
o- / 
...................................................................................................................... 
[...]
   o- backstores 
........................................................................................................... 
[...]
   | o- block 
............................................................................................... 
[Storage Objects: 0]
   | o- fileio 
.............................................................................................. 
[Storage Objects: 0]
   | o- pscsi 
............................................................................................... 
[Storage Objects: 0]
   | o- ramdisk 
............................................................................................. 
[Storage Objects: 0]
   o- iscsi 
......................................................................................................... 
[Targets: 0]
   o- loopback 
...................................................................................................... 
[Targets: 0]
   o- sbp 
........................................................................................................... 
[Targets: 0]
   o- vhost 
......................................................................................................... 
[Targets: 0]
/>

I installed the last version from 
https://fedorahosted.org/releases/t/a/targetcli-fb/
and fortunally I had  python2.7 installed in /usr/local (I don't 
remember why I installed it :D)

builded and installed using python2.7

Thanks Andy for your hint and excuse me if I seemed stubborn :)
Thank to Martin too for his support!

regards
Luigi
