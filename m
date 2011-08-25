From: Maxin B John <maxin.john@gmail.com>
Subject: Re: [PATCH] SCSI: OSD: Kconfig: Select SHA1 and HMAC for OSD
 Initiator library
Date: Thu, 25 Aug 2011 16:10:38 +0300
Message-ID: <CAMhs6YyBj-AsjChnHhqbx1L58Wq0MCM3GN1iPn9QO+f=FHHtFw@mail.gmail.com>
References: <20110811142749.GA26109@maxin>
	<CAMhs6Yy_O33jZ5N7E5UuAtjoRyyEcUG8s4-PQwooX-TJ3Wh=2A@mail.gmail.com>
	<4E4968F0.9050108@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40284 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab1HYNKl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2011 09:10:41 -0400
In-Reply-To: <4E4968F0.9050108@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: rdunlap@xenotime.net, Benny Halevy <bhalevy@panasas.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 15, 2011 at 9:44 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On 08/14/2011 04:18 PM, Maxin B John wrote:
>> On Thu, Aug 11, 2011 at 5:27 PM, Maxin B. John <maxin.john@gmail.com> wrote:
>>> SCSI_OSD_INITIATOR should select CRYPTO_SHA1 and CRYPTO_HMAC. Express this
>>> in Kconfig so that the requirements are met automatically.
>>>
>>> Signed-off-by: Maxin B. John <maxin.john@gmail.com>
>
> OK So actually current osd_initiator code does not use these libraries.
> It should, and I have very old code that started on that (hence the comment),
> but it was never submitted to Kernel. The OSD protocol calls for all kind of
> security levels that use these, but the current code only supports NO_SEC.
>
> I will keep your patch for when security code goes in. Meanwhile I should
> at least remove the stale comment.

Sorry for the delay in reply. Yes, this makes perfect sense to me.

Cheers,
Maxin
