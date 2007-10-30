From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 4/5] qla2xxx: add target mode support
Date: Tue, 30 Oct 2007 08:03:32 -0700
Message-ID: <472747C4.5000003@qlogic.com>
References: <46FBBF8C.80409@qlogic.com>	<20070929151608P.fujita.tomonori@lab.ntt.co.jp>	<46FF8103.5090502@qlogic.com> <20070930143759B.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:38921 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbXJ3PEP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2007 11:04:15 -0400
In-Reply-To: <20070930143759B.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: fujita.tomonori@lab.ntt.co.jp, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, michaelc@cs.wisc.edu, hare@suse.de

FUJITA Tomonori wrote:
> On Sun, 30 Sep 2007 03:57:07 -0700
> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
> 
>> FUJITA Tomonori wrote:
>>> On Thu, 27 Sep 2007 07:34:52 -0700
>>> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
>>>
>>>> FUJITA Tomonori wrote:
>>>>> On Fri, 21 Sep 2007 07:34:18 -0700
>>>>> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
>>>>>
>>>>>> Andrew Vasquez wrote:
>>>>>>> On Sat, 01 Sep 2007, FUJITA Tomonori wrote:
>>>>>>>
>>>>>>>> This adds target mode support to qla2xxx.
>>>>>>>>
>>>>>>>> With set ql2enable_target_mode module parameter to 1, the driver runs
>>>>>>>> in target mode. By default, ql2enable_target_mode is set to 0, and the
>>>>>>>> driver should work in initiator mode as before.
>>>>>>>>
>>>>>>>> The driver could support dual-mode in the future but it doesn't at the
>>>>>>>> moment (we need to add dual-mode support tgt first).
>>>>>>>>
>>>>>>>> It is based on scst qla2xxx target mode driver. Mike converted the
>>>>>>>> driver to use tgt long ago. I changed it to use the latest (mainline)
>>>>>>>> version of qla2xxx driver and tgt, and also converted it to use fc
>>>>>>>> transport class.
>>>>>>> Thanks for doing this.  Some initial comments before a full review is
>>>>>>> complete, As was seen from the initiator updates needed for 24xx
>>>>>>> support, there are comparable changes needed in the area of
>>>>>>> target-mode support for 4gb and 8gb parts.  Also, which ISPs and
>>>>>>> firmwares were exercised with this code?
>>>>>> The patch is still under reviewing and will get done, soon.
>>>>> Great, thinks!
>>>> One more question on typical testing setup.
>>>> I wonder how should I setup the testing environment esp., for the
>>>> target-mode.
>>> Sorry, I should have explained it with the patch.
>>>
>>> Probabaly, you need to compile scsi-misc with the qla2xxx target patch
>>> and the user-space target code.
>> Thank you, I will make it.
>>
>>> 1. scsi-misc + the qla2xxx target patch
can you please help me to locate 'the qla2xxx target patch'?

>> Just for the future references, should I expect same effect from following repository?
>> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-target.git
> 
> Yup, but note that sometimes the tree isn't based on the latest
> scsi-misc.


Thank you,
Seokmann


