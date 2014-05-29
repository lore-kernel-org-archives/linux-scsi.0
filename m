From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: Re: [PATCH] scsi: pm8001: pm8001_hwi.c: Fix for possible null pointer dereference
Date: Fri, 30 May 2014 01:05:22 +0200
Message-ID: <CAFo99gbJQBQbHKz3nxZfW_RMGjHbYKbCeAPSghGkbcJC5u4qLg@mail.gmail.com>
References: <1400429640-11489-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140528112811.GD11953@infradead.org>
	<5385CAA6.7010708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:59664 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaE2XFY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 19:05:24 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so1119774wgh.26
        for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 16:05:22 -0700 (PDT)
In-Reply-To: <5385CAA6.7010708@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Wang Jinpu <xjtuwjp@gmail.com>, lindar_liu <lindar_liu@usish.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi

Quite rightly, this is what cppcheck reacts.
Ok, I'll send a patch for that instead then.


Best regards
Rickard Strandqvist


2014-05-28 13:38 GMT+02:00 Tomas Henzl <thenzl@redhat.com>:
> On 05/28/2014 01:28 PM, Christoph Hellwig wrote:
>> On Sun, May 18, 2014 at 06:14:00PM +0200, Rickard Strandqvist wrote:
>>> There is otherwise a risk of a possible null pointer dereference.
>>>
>>> Was largely found by using a static code analysis program called cppcheck.
>> I can't see how dev->lldd_dev would be NULL here.
>
> The analysis program likely can't know that, the reason for this report
> it that dev->lldd_dev is tested for not being null several lines below -
> http://lxr.free-electrons.com/source/drivers/scsi/pm8001/pm8001_hwi.c#L4447
> So the other option is to remove this^ test.
>
