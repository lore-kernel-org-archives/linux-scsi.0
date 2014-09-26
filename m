From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: next-20140925 build: 1 failures 106 warnings (next-20140925)
Date: Fri, 26 Sep 2014 12:02:03 +0530
Message-ID: <CAK=zhgro-VnQ5v85SLg+GMH8uMoiYWF-RiiZpQnhXmuZtsS+bA@mail.gmail.com>
References: <E1XX7vn-0003PS-Vu@cassiel.sirena.org.uk>
	<20140925153120.GX27755@sirena.org.uk>
	<20140925154652.GA29864@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og128.obsmtp.com ([64.18.2.121]:38113 "EHLO
	exprod7og128.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbaIZGcG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Sep 2014 02:32:06 -0400
Received: by mail-oi0-f54.google.com with SMTP id a3so9149506oib.41
        for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2014 23:32:04 -0700 (PDT)
In-Reply-To: <20140925154652.GA29864@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mark Brown <broonie@kernel.org>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, kernel-build-reports@lists.linaro.org, linaro-kernel@lists.linaro.org, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, Joe Maloy <joe.maloy@avagotech.com>

Hi Mark,

Can you please let me known whether you are observing these warning
messages even after inclusion of below patch

http://git.infradead.org/users/hch/scsi-queue.git/commitdiff/f78f694c34ae6fdc29f5e80abb2dbb894f961772

Regards,
Sreekanth

On Thu, Sep 25, 2014 at 9:16 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Sep 25, 2014 at 04:31:20PM +0100, Mark Brown wrote:
>> On Thu, Sep 25, 2014 at 01:13:56PM +0100, Build bot for Mark Brown wrote:
>>
>> >     arm-allmodconfig
>> > ERROR: "__aeabi_uldivmod" [drivers/scsi/mpt2sas/mpt2sas.ko] undefined!
>>
>> Today's ARM allmodconfig fails to build due to a call to a GCC intrinsic
>> being emitted from the mpt2sas module - I've not made any effort to
>> investigate this myself yet, unfortunately there's been a build error in
>> this configuration for arch/arm for the past week or so which means that
>> the error may not have been introduced today.
>
> http://git.infradead.org/users/hch/scsi-queue.git/commitdiff/f78f694c34ae6fdc29f5e80abb2dbb894f961772
>
> I just need James to pull the latests scsi-queue tree changes..
>
