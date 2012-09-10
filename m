From: Rich <rercola@pha.jhu.edu>
Subject: Re: Odd behavior of a "SAS-2" backplane with SGPIO commands
Date: Mon, 10 Sep 2012 12:07:45 -0400
Message-ID: <CAOeNLupUgCbNCfs8mOWgu4Xfv2S=Lrjt0Hdi42ijwsS1bSJi4w@mail.gmail.com>
References: <CAOeNLuruup-22wAFgR0b+cPc0nCf_jUm0teDHB7DLnRmcHtTog@mail.gmail.com>
	<20120818235247.GO19851@reaktio.net>
	<CAOeNLuob_oq3HBV1w3W64hT4c1qSjE9xsm0_Az3+KTHnEN3QbQ@mail.gmail.com>
	<20120819102531.GP19851@reaktio.net>
	<5030E0F8.5@gmail.com>
	<20120819131309.GQ19851@reaktio.net>
	<CAOeNLupdpdDqQUhabgQhZjF0rP+XcTV6jF-XhYW3=KUfmW=R4Q@mail.gmail.com>
	<20120910134711.GJ8912@reaktio.net>
	<20120910180142.6adfd3f3@harpe.intellique.com>
	<20120910160407.GK8912@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64250 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709Ab2IJQHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2012 12:07:46 -0400
Received: by vcbfy27 with SMTP id fy27so1534677vcb.19
        for <linux-scsi@vger.kernel.org>; Mon, 10 Sep 2012 09:07:45 -0700 (PDT)
In-Reply-To: <20120910160407.GK8912@reaktio.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?UGFzaSBLw6Rya2vDpGluZW4=?= <pasik@iki.fi>
Cc: Emmanuel Florac <eflorac@intellique.com>, Harri Olin <harri.olin@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Sep 10, 2012 at 12:04 PM, Pasi K=C3=A4rkk=C3=A4inen <pasik@iki.=
fi> wrote:
> On Mon, Sep 10, 2012 at 06:01:42PM +0200, Emmanuel Florac wrote:
>> Le Mon, 10 Sep 2012 16:47:11 +0300
>> Pasi K=C3=A4rkk=C3=A4inen <pasik@iki.fi> =C3=A9crivait:
>>
>> > Any replies from Supermicro/LSI ?
>> >
>>
>> Only loosely related, but Supermicro replaced recently my 846E26 (du=
al
>> expander backplane) with 846E16 (single expander). Apparently they
>> gave up getting the E26 to work properly or something: LSI expander
>> firmware problem.
>>
>> In another (very large scale, high end) setup, many different 60 slo=
ts
>> 5 LSI expanders chassis had a general failure of the 5th drawer.
>> Another LSI SAS-2 expander firmware problem.
>>
>> I could start a rant about the evil of proprietary firmware, etc. Yo=
u
>> get my meaning :)
>>
>
> Yeah, this is a good example why we're trying to get the LEDs working=
 with
> direct attach (non-expander) backplanes :)
>
> -- Pasi
>

I don't have anything useful for people, other than that they have
shown me an HBA firmware that fixes the LED problem but has other
problems they're still debugging.

So there does exist code for this firmware which will fix this problem.

[I don't disagree on the evils of proprietary firmware, but this is
the hand I've been dealt, so.]

- Rich
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
