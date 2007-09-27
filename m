From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 4/5] qla2xxx: add target mode support
Date: Thu, 27 Sep 2007 07:34:52 -0700
Message-ID: <46FBBF8C.80409@qlogic.com>
References: <200708311703.l7VH3NkK016220@mbox.iij4u.or.jp>	<20070905150534.GJ17977@plap.qlogic.org>	<46F3D66A.9010000@qlogic.com> <20070923231416K.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:56900 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201AbXI0OfY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2007 10:35:24 -0400
In-Reply-To: <20070923231416K.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, michaelc@cs.wisc.edu, hare@suse.de, fujita.tomonori@lab.ntt.co.jp

FUJITA Tomonori wrote:
> On Fri, 21 Sep 2007 07:34:18 -0700
> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
> 
>> Andrew Vasquez wrote:
>>> On Sat, 01 Sep 2007, FUJITA Tomonori wrote:
>>>
>>>> This adds target mode support to qla2xxx.
>>>>
>>>> With set ql2enable_target_mode module parameter to 1, the driver runs
>>>> in target mode. By default, ql2enable_target_mode is set to 0, and the
>>>> driver should work in initiator mode as before.
>>>>
>>>> The driver could support dual-mode in the future but it doesn't at the
>>>> moment (we need to add dual-mode support tgt first).
>>>>
>>>> It is based on scst qla2xxx target mode driver. Mike converted the
>>>> driver to use tgt long ago. I changed it to use the latest (mainline)
>>>> version of qla2xxx driver and tgt, and also converted it to use fc
>>>> transport class.
>>> Thanks for doing this.  Some initial comments before a full review is
>>> complete, As was seen from the initiator updates needed for 24xx
>>> support, there are comparable changes needed in the area of
>>> target-mode support for 4gb and 8gb parts.  Also, which ISPs and
>>> firmwares were exercised with this code?
>> The patch is still under reviewing and will get done, soon.
> 
> Great, thinks!
One more question on typical testing setup.
I wonder how should I setup the testing environment esp., for the target-mode.
If you have, could you share the details of the layout of the environment that you have had used for the feature verification?
Also, it would be great if shared with me for those specific test cases that need to be in place.
I will try to add more cases on top of it if there are.

Thank you,
Seokmann
