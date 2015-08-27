From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH 0/2] mpt3sas: Reference counting fixes from in-flight mpt2sas
Date: Thu, 27 Aug 2015 10:37:51 +0530
Message-ID: <CAK=zhgr6gpyW9-+VYcW4Aiv8-m-qdQ=fTeEAm2=OPUDN0FbOAQ@mail.gmail.com>
References: <1440562184-23945-1-git-send-email-nab@daterainc.com>
	<20150826235434.GA8843@mail.thefacebook.com>
	<1440633514.31814.3.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:34295 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbbH0FHw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2015 01:07:52 -0400
Received: by obbfr1 with SMTP id fr1so9721663obb.1
        for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2015 22:07:51 -0700 (PDT)
In-Reply-To: <1440633514.31814.3.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Calvin Owens <calvinowens@fb.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, "MPT-FusionLinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>, kernel-team@fb.com

HI Nicholas & Calvin,

Thanks for the patchset. Sure We will review and we do some unit
testing on this patch series. Currently my bandwidth is occupied with
some internal activity, so by end of next week I will acknowledge this
series if all the thing are fine with this patch series.

Thanks,
Sreekanth

On Thu, Aug 27, 2015 at 5:28 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> On Wed, 2015-08-26 at 16:54 -0700, Calvin Owens wrote:
>> On Wednesday 08/26 at 04:09 +0000, Nicholas A. Bellinger wrote:
>> > From: Nicholas Bellinger <nab@linux-iscsi.org>
>> >
>> > Hi James & Co,
>> >
>> > This series is a mpt3sas forward port of Calvin Owens' in-flight
>> > reference counting bugfixes for mpt2sas LLD code here:
>> >
>> > [PATCH v4 0/2] Fixes for memory corruption in mpt2sas
>> > http://marc.info/?l=linux-scsi&m=143951695904115&w=2
>>
>> Nicholas,
>>
>> I'm glad to hear these fixes were helpful! I was planning on porting to
>> mpt3sas in the near future, thanks for saving me the trouble :)
>>
>
> Would you mind giving this series the once over, and add your
> Reviewed-by as well..?
>
> Sreekanth + Avago folks, can you please do the same for Calvin's mpt2sas
> series and this series..?
>
> This has been a long-standing issue with mpt*sas LLD code and really
> needs to be addressed for upstream.
>
> Thank you,
>
> --nab
>
