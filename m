From: Rich <rercola@pha.jhu.edu>
Subject: Re: Odd behavior of a "SAS-2" backplane with SGPIO commands
Date: Thu, 1 Nov 2012 11:55:25 -0400
Message-ID: <CAOeNLurHZPpo8mV3u5cTQ_mZL1buL4LUv1udyhn7fNZYFmOHQg@mail.gmail.com>
References: <CAOeNLuob_oq3HBV1w3W64hT4c1qSjE9xsm0_Az3+KTHnEN3QbQ@mail.gmail.com>
	<20120819102531.GP19851@reaktio.net>
	<5030E0F8.5@gmail.com>
	<20120819131309.GQ19851@reaktio.net>
	<CAOeNLupdpdDqQUhabgQhZjF0rP+XcTV6jF-XhYW3=KUfmW=R4Q@mail.gmail.com>
	<20120910134711.GJ8912@reaktio.net>
	<20120910180142.6adfd3f3@harpe.intellique.com>
	<20120910160407.GK8912@reaktio.net>
	<CAOeNLupUgCbNCfs8mOWgu4Xfv2S=Lrjt0Hdi42ijwsS1bSJi4w@mail.gmail.com>
	<20120910161315.GL8912@reaktio.net>
	<20121021124649.GS8912@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34168 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964810Ab2KAPz0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Nov 2012 11:55:26 -0400
Received: by mail-vb0-f46.google.com with SMTP id ff1so2812618vbb.19
        for <linux-scsi@vger.kernel.org>; Thu, 01 Nov 2012 08:55:25 -0700 (PDT)
In-Reply-To: <20121021124649.GS8912@reaktio.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?UGFzaSBLw6Rya2vDpGluZW4=?= <pasik@iki.fi>
Cc: Emmanuel Florac <eflorac@intellique.com>, Harri Olin <harri.olin@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sun, Oct 21, 2012 at 8:46 AM, Pasi K=C3=A4rkk=C3=A4inen <pasik@iki.f=
i> wrote:
> On Mon, Sep 10, 2012 at 07:13:15PM +0300, Pasi K=C3=A4rkk=C3=A4inen w=
rote:
>> On Mon, Sep 10, 2012 at 12:07:45PM -0400, Rich wrote:
>> > On Mon, Sep 10, 2012 at 12:04 PM, Pasi K=C3=A4rkk=C3=A4inen <pasik=
@iki.fi> wrote:
>> > > On Mon, Sep 10, 2012 at 06:01:42PM +0200, Emmanuel Florac wrote:
>> > >> Le Mon, 10 Sep 2012 16:47:11 +0300
>> > >> Pasi K=C3=A4rkk=C3=A4inen <pasik@iki.fi> =C3=A9crivait:
>> > >>
>> > >> > Any replies from Supermicro/LSI ?
>> > >> >
>> > >>
>> > >> Only loosely related, but Supermicro replaced recently my 846E2=
6 (dual
>> > >> expander backplane) with 846E16 (single expander). Apparently t=
hey
>> > >> gave up getting the E26 to work properly or something: LSI expa=
nder
>> > >> firmware problem.
>> > >>
>> > >> In another (very large scale, high end) setup, many different 6=
0 slots
>> > >> 5 LSI expanders chassis had a general failure of the 5th drawer=
=2E
>> > >> Another LSI SAS-2 expander firmware problem.
>> > >>
>> > >> I could start a rant about the evil of proprietary firmware, et=
c. You
>> > >> get my meaning :)
>> > >>
>> > >
>> > > Yeah, this is a good example why we're trying to get the LEDs wo=
rking with
>> > > direct attach (non-expander) backplanes :)
>> > >
>> > > -- Pasi
>> > >
>> >
>> > I don't have anything useful for people, other than that they have
>> > shown me an HBA firmware that fixes the LED problem but has other
>> > problems they're still debugging.
>> >
>> > So there does exist code for this firmware which will fix this pro=
blem.
>> >
>>
>> That's good to know! Let's hope the fix ends up in an official
>> LSI HBA firmware update in not-so-distant future.
>>
>
> Btw what was the version number of the LED-fixed LSI firmware?
> I'm just wondering in which firmware series the fix might end up bein=
g included..
>
> Also: Any updates on this?
>
> Thanks,
>
> -- Pasi
>

The fixed FW I had demonstrated for me was still 14.0.0.0 - I've been
told it'll be rolled into the FW release currently on the site and
posted at some point, but that they have no ETA for that.

- Rich
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
