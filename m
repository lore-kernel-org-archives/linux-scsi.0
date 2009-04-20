From: Ashutosh Naik <ashutosh.naik@gmail.com>
Subject: Re: [PATCH]ibft: Fix the display of a few fields in the NIC attribute
	structure in sysfs
Date: Mon, 20 Apr 2009 21:30:00 +0530
Message-ID: <81083a450904200900p7f885bf6v1d50a3429293e2f1@mail.gmail.com>
References: <81083a450904110629j93c5c2j2c1250e9822c3888@mail.gmail.com>
	 <1239472568.3416.11.camel@mulgrave.int.hansenpartnership.com>
	 <200904120907.08828.ketuzsezr@darnok.org>
	 <20090415143744.84d6c598.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:30135 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797AbZDTQAB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2009 12:00:01 -0400
In-Reply-To: <20090415143744.84d6c598.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ketuzsezr@darnok.org, James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, pjones@redhat.com, konradr@linux.vnet.ibm.com, vishnu@chelsio.com

On Thu, Apr 16, 2009 at 3:07 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sun, 12 Apr 2009 09:06:59 -0400
> Konrad Rzeszutek <ketuzsezr@darnok.org> wrote:
>
>> > The second question is who picks this up? =A0The drivers/firmware
>> > directory doesn't seem to have a dedicated tree, so I can take thi=
s
>> > through the SCSI tree if required or Andrew can take it through -m=
m.
>>
>> Which way works best for everybody? I was thinking SCSI, since the e=
nd result
>> of this module is to configure the storage used to bootstrap the box=
=2E
>
> I can merge merge it later this week.
>
> However...
>
>
> : From: Ashutosh Naik <ashutosh.naik@gmail.com>
> :
> : Fix the display of a few fields in the iBFT NIC attribute structure=
 in
> : sysfs.
<snip>

> The changelog is bad.
>
> What does "fix" mean? =A0What does the old output look like and how d=
oes
> this patch change it?
>
> This matters, because this is a userspace interface and who knows, th=
ere
> might be applications out there which somehow depend on the old and
> broken behaviour.
>
> Of course, that might be totally silly and unrealistic but because we
> weren't told what the patch actually does, how can I tell?
>
> Please send a new and complete description of this change, thanks.

Sorry for the delay.

Here is an updated Changelog

The patch ensures that on, if the DHCP
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
