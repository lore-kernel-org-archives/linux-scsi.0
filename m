From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Performance of SCST versus STGT
Date: Tue, 22 Jan 2008 15:20:44 +0300
Message-ID: <4795DF9C.4000809@vlnb.net>
References: <e2e108260801200136g7f17b8a0g89a54cc1d73bbc34@mail.gmail.com>	<20080122122657R.fujita.tomonori@lab.ntt.co.jp>	<4795D479.1080805@vlnb.net> <20080122204845E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:55168 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751947AbYAVMUi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 07:20:38 -0500
In-Reply-To: <20080122204845E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bart.vanassche@gmail.com, stgt-devel@lists.berlios.de, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, pw@osc.edu, James.Bottomley@hansenpartnership.com, erezz@voltaire.com

FUJITA Tomonori wrote:
> On Tue, 22 Jan 2008 14:33:13 +0300
> Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> 
> 
>>FUJITA Tomonori wrote:
>>
>>>The big problem of stgt iSER is disk I/Os (move data between disk and
>>>page cache). We need a proper asynchronous I/O mechanism, however,
>>>Linux doesn't provide such and we use a workaround, which incurs large
>>>latency. I guess, we cannot solve this until syslets is merged into
>>>mainline.
>>
>>Hmm, SCST also doesn't have ability to use asynchronous I/O, but that 
>>doesn't prevent it from showing good performance.
> 
> 
> I don't know how SCST performs I/Os, but surely, in kernel space, you
> can performs I/Os asynchronously.

Sure, but currently it all synchronous

> Or you use an event notification
> mechanism with multiple kernel threads performing I/Os synchronously.
> 
> Xen blktap has the same problem as stgt. IIRC, Xen mainline uses a
> kernel patch to add a proper event notification to AIO though redhat
> uses the same workaround as stgt instead of applying the kernel patch.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

