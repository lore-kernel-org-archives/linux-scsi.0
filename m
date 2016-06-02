From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: Performance degradation on 4.6
Date: Thu, 2 Jun 2016 09:18:38 -0600
Message-ID: <CAANLjForcsQHyeJ=Jm7MO6RwbhgHoWBVTUPG+UcxDsu7C7PrKQ@mail.gmail.com>
References: <CAANLjFp28MkaMjWKwXnMGHPCX2S_g_RKOhXqHc9dYVJvMgqvVw@mail.gmail.com>
	<1464814819.10899.3.camel@haakon3.risingtidesystems.com>
	<20160602113712.GA24605@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33859 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892AbcFBPSk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2016 11:18:40 -0400
Received: by mail-oi0-f65.google.com with SMTP id e80so3876131oig.1
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jun 2016 08:18:39 -0700 (PDT)
In-Reply-To: <20160602113712.GA24605@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>

I'm trying to bisect this (target,initiator, kernel commit), but I'm
having issues replicating my 4.4 results at the moment. Once I get
that done, hopefully I can get to the bottom of where things are
slowing down.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Thu, Jun 2, 2016 at 5:37 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Jun 01, 2016 at 02:00:19PM -0700, Nicholas A. Bellinger wrote:
>> Hi Robert,
>>
>> Adding HCH + Sagi CC, as there have been significant changes made in
>> RDMA for v4.6 code.
>
> And 4.5 for that matter.  It would be really useful to figure out
> if it's the target or the initiator that regressed, and weather it's in
> 4.5 or 4.6.
