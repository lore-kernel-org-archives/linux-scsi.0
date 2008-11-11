From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: best userspace iscsi target lib?
Date: Tue, 11 Nov 2008 18:12:25 +0200
Message-ID: <4919AEE9.3040802@panasas.com>
References: <4918B5B2.8050003@garzik.org>	<20081111152229J.fujita.tomonori@lab.ntt.co.jp>	<4919917C.4030109@garzik.org> <20081112000239T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:14131 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751458AbYKKQMN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Nov 2008 11:12:13 -0500
In-Reply-To: <20081112000239T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jeff@garzik.org, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> On Tue, 11 Nov 2008 09:06:52 -0500
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> FUJITA Tomonori wrote:
>>> On Mon, 10 Nov 2008 17:29:06 -0500
>>> Jeff Garzik <jeff@garzik.org> wrote:
>>>
>>>> Can someone recommend an open source userspace library that enables one 
>>>> to implement a userspace iSCSI target?
>>> I'm not sure there is an open source userspace library enables you to
>>> easily implement your own userspace iSCSI target but there are some
>>> userspace iSCSI target implementations, which might useful.
>>>
>>> Some Linux distributions use:
>>>
>>> http://stgt.berlios.de/
>>>
>>> OpenSolaris also has one:
>>>
>>> http://opensolaris.org/os/project/iscsitgt/
>>>
>>> *BSD also have userspace iSCSI target implementations.
>> Thanks much, I will take a look.  I have already found and read the code 
>> for NetBSD's iSCSI target.
>>
>> I am mainly interested in 100% userspace solution, because in my case, 
>> the storage software (distributed goop) is also in userspace.  Something 
>> that exports through the kernel actually adds overhead, when a 
>> straight-to-sockets userspace implementation would be more efficient.
> 
> All the implementations that I referred to above are 100% userspace
> solution (if I correctly remember *BSD's implementations).
> 
> You might think that stgt is a kernel space solution but it's 100%
> userspace solution if you use only its iSCSI (or FCoE) support. As you
> expect, it's just a userspace daemon. It doesn't require any fancy
> kernel features.
> 
> About OSD support, I think that Pete and other osc.edu people
> implemented iSCSI OSD target with stgt (though I've not merged their
> OSD code to stgt or tried it yet):
> 

Do not use these URL's they are out of date. The OSC OSD project
is now hosted on open-osd.org git tree's.

Look here for latest git tree and instructions:
http://www.open-osd.org/bin/view/Main/OscOsdProject

We also have stgt + osd-patches hosted as a sub-module under
the OSC OSD target.

Boaz
