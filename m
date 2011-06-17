From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
Date: Fri, 17 Jun 2011 18:12:14 +0200
Message-ID: <BANLkTinMzyQWZvxiRw4tvZBwW5xsxvMz-Q@mail.gmail.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com>
 <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com>
 <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com>
 <1308241506.2436.44.camel@mulgrave> <20110616181943.GB1439@kroah.com>
 <1308256290.2436.143.camel@mulgrave> <BANLkTikfCMR_=5Jp7tLhM_Wr3vxihEL+rA@mail.gmail.com>
 <1308264321.2436.161.camel@mulgrave> <BANLkTinvfmU0dszQyu4U=Pw3_BtrmOUi_g@mail.gmail.com>
 <1308320844.2586.14.camel@mulgrave> <BANLkTikMa6vO4m3tk1O2mtj76k6s66f2gQ@mail.gmail.com>
 <1308322193.2586.30.camel@mulgrave> <BANLkTinywFK3yAxN51O7RDYyqeNRHBRThA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTinywFK3yAxN51O7RDYyqeNRHBRThA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 17, 2011 at 17:39, Kay Sievers <kay.sievers@vrfy.org> wrote=
:
> On Fri, Jun 17, 2011 at 16:49, James Bottomley

>> So this is subsystem specific. =C2=A0For the case of a SCSI enclosur=
e, I can
>> answer that it's actually burned into the enclosure firmware. =C2=A0=
When you
>> build an enclosure with labels, the label names are stored in a
>> diagnostic page. =C2=A0We can actually interrogate the enclosure dir=
ectly or
>> use the ses driver to get these names mapped to current devices.
>
> To me this sounds like a nice name on top of the current bunch of
> names, not like a 'preferred' name.
>
> I still don't like to introduce any new facility to the kernel that
> can handle only one single name. Reality the last years has taught us
> a very different story, and we've walked a long way to get where we
> are. I really don't believe single names will ever work, it's just a
> nice theory.

I might need to clarify this a bit.

I have no problem in general to add a 'alias' to every disk, and use
that when stuff is logged. Just the same way the netifs have an alias.
Sure, it might be useful for some use cases. And if that helps to
solve any real problem, we should just do it.

I just want to make clear, that I don't think that it is anywhere near
to a solution for the problems which are described here. And that
nobody should see this as an excuse not to get their stuff together
and work on the problem, which is that we don't have machine-readable
error and debug from the kernel and a smart syslog.

If we had that, I'm very sure nobody would even ask for a 'pretty
name' in the kernel, and I think that is a good indication that we are
not on the right track here.

Kay
