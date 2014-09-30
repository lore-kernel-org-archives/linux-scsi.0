From: Andy Grover <agrover@redhat.com>
Subject: Re: targetcli do not show iscsi
Date: Tue, 30 Sep 2014 08:21:16 -0700
Message-ID: <542ACA6C.104@redhat.com>
References: <542A6F44.3070802@gmail.com> <542A7037.6050909@netiant.com> <542A722E.5030109@gmail.com> <542A73BE.2080501@netiant.com> <542A75F1.8070706@gmail.com> <542A77D6.4090109@netiant.com> <542A7ADD.3040804@gmail.com> <542A7BC9.2050708@netiant.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaI3PVZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2014 11:21:25 -0400
In-Reply-To: <542A7BC9.2050708@netiant.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jerome Martin <jxm@netiant.com>, Luigi Tarenga <luigi.tarenga@gmail.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On 09/30/2014 02:45 AM, Jerome Martin wrote:
>
>
> On 09/30/2014 11:41 AM, Luigi Tarenga wrote:
>>
>> On 09/30/2014 11:28 AM, Jerome Martin wrote:
>>> Luigi,
>>>
>>> Out of curiosity, does it work as expected with the stock fedora
>>> packaged kernel ?
>>>
>>> Best,
>>> --
>>> Jerome
>>>
>>
>> didn't test that configuration and since I can't find module
>> iscsi_target_mod in stock

iscsi is not a supported fabric on rhel/centos 6. Only FCoE uses LIO. 
scsi-target-utils (tgt) is the supported iscsi target on rhel6. rhel7 
uses LIO for both, as does Fedora.

Regards -- Andy

