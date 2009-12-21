From: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCHv2 0/4] scsi: export and clean up headers
Date: Mon, 21 Dec 2009 09:14:14 -0500
Message-ID: <8bd0f97a0912210614p37029355yabd4388d4bf02172@mail.gmail.com>
References: <20090929103353.GA11183@redhat.com> <20090929124347.GA11375@infradead.org>
	<20090930071555.GA13915@merkur.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:59528 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbZLUOOe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2009 09:14:34 -0500
In-Reply-To: <20090930071555.GA13915@merkur.ravnborg.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Michael S. Tsirkin" <mst@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>, Ulrich Drepper <drepper@redhat.com>

On Wed, Sep 30, 2009 at 02:15, Sam Ravnborg wrote:
> On Tue, Sep 29, 2009 at 08:43:47AM -0400, Christoph Hellwig wrote:
>> On Tue, Sep 29, 2009 at 12:33:53PM +0200, Michael S. Tsirkin wrote:
>> > This implements a minor cleanup of exported scsi headers,
>> > and adds export of headers that are de-facto used by userspace.
>> > The patches are on top of 2.6.32-rc1.
>> > Can these be queued for 2.6.32?
>> > Thanks.
>>
>> Before we do anything in this area we need to find an agreement who
>> owns /usr/include/scsi/ . =C2=A0Right now that's glibc, and if we wa=
nt to
>> change it to the kernel headers we need to find a transition agreeme=
nt
>> with the glibc maintainer (aka mostly Uli).
>
> The scsi headers are exported. So it does not matter if glibc or any
> other libc for that amtter uses the headers or not.
> Exported headers has some rules to follow and scsi are no exception h=
ere.
>
> Now if we get the scsi headers in good shape then and only then we ca=
n
> go to glibc people and tell them that we have a better set of scsi he=
aders
> than they have.
>
> Postponing updates to the exported scsi headers just beacause we do n=
ot
> have any users of them at the moment is the wrong thing to do.
> We should rather use the opportunity to streamline the exported heade=
rs
> so we have a superior set of headers to offer.

can we get these fixes merged ?  i dont see them in 2.6.33-rc1 ...
-mike
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
