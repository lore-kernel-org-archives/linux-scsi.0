From: Grant Grundler <grundler@google.com>
Subject: Re: libata / scsi separation
Date: Wed, 10 Dec 2008 09:21:38 -0800
Message-ID: <da824cf30812100921l58526156u9230650556a36ab9@mail.gmail.com>
References: <493B022B.3050406@ru.mvista.com> <493B0867.5020700@ru.mvista.com>
	 <1228662298.3501.19.camel@localhost.localdomain>
	 <20081209222113.GU25548@parisc-linux.org> <493F2151.6010702@gmail.com>
	 <da824cf30812091829g180b3e45i843e356364bc2f9f@mail.gmail.com>
	 <493F2DA9.7040008@gmail.com>
	 <da824cf30812091923j241f915dmbcb27245c0d0491b@mail.gmail.com>
	 <493F3B33.8010607@gmail.com> <20081210152445.GW25548@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:60923 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbYLJRVw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 12:21:52 -0500
Received: from spaceape23.eur.corp.google.com (spaceape23.eur.corp.google.com [172.28.16.75])
	by smtp-out.google.com with ESMTP id mBAHLpWC031341
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2008 09:21:51 -0800
Received: from bwz13 (bwz13.prod.google.com [10.188.26.13])
	by spaceape23.eur.corp.google.com with ESMTP id mBAHLnkF013515
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2008 09:21:49 -0800
Received: by bwz13 with SMTP id 13so28299bwz.7
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2008 09:21:49 -0800 (PST)
In-Reply-To: <20081210152445.GW25548@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Dec 10, 2008 at 7:24 AM, Matthew Wilcox <matthew@wil.cx> wrote:
...
> This would work, but (ignoring the political / standardisation efforts
> required to make this happen), this is just a cop-out.  When networking
> people were first faced with gigabit, they tried the same thing (oooh,
> 9000 byte packets, oooh, TCP Offload, etc), all in the name of passing
> larger amounts of data to the card in a single transaction so they
> didn't have to fix their per-transaction overheads.

Willy,
I agree with your points except for one: TCP Offload.

James Bottomley gets credit for publicly observing that storage
protocols have been offloaded for ages. I once worked on a SCSI
controller that interrupted on every phase change (early 90's). Next
generation of SCSI controllers had offload. Same thing occured
to FC in the late 90s and legacy PATA is being replaced with
equivalent SATA offload engines more recently. Enough examples.

> Users weren't interested.  They wanted to keep sending 1500 byte packets
> (because most equipment couldn't handle jumbo frames) and they wanted
> netfilter and SACK and all the other goodies that the Linux networking
> stack offered and the card's TCP stack didn't.
>
> We should stop denying that users actually want to do 4k IOs and just
> get on with fixing the storage stack to cope with lots of them.

+1

thanks,
grant
