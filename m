From: Andy Grover <agrover@redhat.com>
Subject: Re: target userspace utils (rtsadmin) project is dysfunctional
Date: Mon, 12 Sep 2011 12:56:31 -0700
Message-ID: <4E6E63EF.2050608@redhat.com>
References: <4E69BB29.2030800@redhat.com>	<CAN4SboCi7C9iB+GNH85yfMkvDQdf4BN4CunUuJjvc+a-cfaCFQ@mail.gmail.com> <CAN4SboA8z1drZxbs0CtKPLtQ+n4bY0UqrRSVt_ZB-4TgdBKtBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab1ILT4e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2011 15:56:34 -0400
In-Reply-To: <CAN4SboA8z1drZxbs0CtKPLtQ+n4bY0UqrRSVt_ZB-4TgdBKtBA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jerome Martin <jxm@risingtidesystems.com>
Cc: Nicholas Bellinger <nab@risingtidesystems.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Jerome,

You have released the code and publish repos using a GPL-compatible
license. These are the good things, but you're doing almost everything
else wrong.

* Lacking FOSS infrastructure. No dedicated list, no releases, no
bugtracking, no roadmap or communication on future plans.

* CLA is a barrier to external contributors. I can't fix things that ar=
e
important to me but you've rated a low priority. e.g. removing lio-util=
s
dep for saving state. Even if I was willing to sign the CLA, you've
positioned rtsadmin "community edition" as the little brother to your
proprietary product. I'm betting features I would want to add (remote
API?) would conflict with features you've slated for your EnterPrise
Edition, and likely would be rejected. FOSS development is supposed to
be mutually beneficial, but requiring a CLA and restricting external
contributors' rights by using a restrictive AGPLv3 license means things
are tilted too far in your favor.

* You named the utility after your company, not the project name. This
obviously isn't a huge deal (I can patch it to have a better name) but
it seems to say you'd rather take all the credit for the utility, and
will make decisions for marketing reasons that are not in the best
interest of your users.


I can fix all these things for myself and the rest of the FOSS communit=
y
by forking the project. Here's what needs to happen:

* Set up proper infrastructure. This is a simple as rehosting on github
or sf.net. Set up a mailing list. Release something. TALK about your
plans. You need to do these things before you can expect to get serious
external contributor attention.

* Change your patch acceptance policies. The CLA must go. Proprietary
value-add is ok but it should be a separate component. (If you can't do
this, it means you're slicing things too thin.) A BSD license instead o=
f
AGPL may be more suitable. You cannot limit the FOSS project based upon
it duplicating features from your proprietary one - yesterday's special
sauce is today's commodity feature.

* Rename it. lio-utils was a decent name -- a user thinks "hey that mus=
t
be utils for using LIO, I should install it!" but rtsadmin =3D=3D "wher=
e is
this rts thing I am admining?" Fail. I'd suggest tcmadmin or
targetadmin. Feel free to use rtsadmin for your EE version.


=46inally, let me say I have had positive experiences working with both
you (Jerome) and Nick. I've worked at places where sometimes the
company's interests (at least as it perceived them) did not align with
the FOSS way. Your code is valuable enough to fork rather than start
over, but not so valuable that the current state (of licensing,
especially) is acceptable.


Regards -- Andy


On 09/10/2011 10:37 PM, Jerome Martin wrote:
> Repost including target-devel and linux-scsi lists.
> Sorry for the noise.
>=20
> On Sat, Sep 10, 2011 at 10:30 PM, Jerome Martin
> <jxm@risingtidesystems.com> wrote:
>> Hi Andy,
>> I am not so much interested in your "calculation" than on having a l=
ist of
>> checkpoints that you feel would be important to improve in order to =
have a
>> better OSS project. In all good faith, I can assure you this is all =
I (we)
>> are looking for, within the limits of time & resources available.
>> As for the emails I did not (never, really ?) answer, apart from the
>> vacation pointed out by Nic, I guess I must have erased part of my m=
ailbox
>> inadvertently then, because I do not have them in my todo box, in wh=
ich I
>> normally have everything not handled yet.
>>
>> Anyway, thanks for saying rtsadmin is a nice piece of code, I hope w=
e can
>> improve it with as much enlightened (read from people using it ;-) )=
 input
>> as possible.
>> And again, I really am eager to take your suggestions about how to i=
mprove
>> the docs and processes, these are vast topics and the best places to=
 start
>> might not be always intuitive when you are deep into the code itself=
=2E I
>> engaged huge efforts in making rtsadmin self-documenting as possible=
, with a
>> lot of documentation in the code itself, but clearly this is not eno=
ugh. I
>> assume there might be some easy to do pieces of doc that could impro=
ve
>> dramatically the user experience, but am unsure what they are (insta=
ll ?
>> packaging ? building from source ? quickstart ? so many things to do=
=2E..).
>> As for what's planned, the next items on my community todo are to ad=
apt the
>> build process to export a versioned tarball so distros and everyone =
else can
>> get a fixed version release without having to go through the git-dep=
endent
>> build process, fix the tags exports to the community repository (som=
e script
>> is blocking somewhere in the chain of autocommits) and write a quick=
 "how to
>> build packages" howto. Do those sound reasonable to you or would you=
 put
>> something higher on the priority list ?
>> One last thing I need to say is that the company as a whole as a ver=
y
>> favorable view of anything that can improve the community experience=
, so
>> every misimplementation of that policy is to blame on me. Unfortunat=
ely I
>> might have a hard time managing priorities and workload, and this ap=
parently
>> led to regrettable effects on the OSS project.
>> Thanks for both the kind and critical words, but now you've said too=
 much to
>> withhold the constructive mentoring any longer ;-)
>> Kind Regards,
>> Jerome
>> On Fri, Sep 9, 2011 at 10:07 AM, Andy Grover <agrover@redhat.com> wr=
ote:
>>>
>>> Hi Jerome and Nick,
>>>
>>> I happened upon this website:
>>>
>>>
>>> http://www.theopensourceway.org/book/The_Open_Source_Way-How_to_tel=
l_if_a_FLOSS_project_is_doomed_to_FAIL.html
>>>
>>> According to my calculations (available upon request), rtsadmin com=
es in
>>> at 220 points: "so much fail, your code should have its own reality=
 TV
>>> show".
>>>
>>> I could also add some more like "primary developer never responds t=
o
>>> email", "CLA discourages external contributions", and "uses executa=
ble
>>> name as corporate marketing tool".
>>>
>>> Admittedly rtsadmin is a nice piece of code, thanks btw, but your
>>> company is falling short of accepted standards for stewardship of a
>>> FLOSS project. Please tell me why we all wouldn't be better off if =
I
>>> forked rtsadmin tomorrow.
>>>
>>> Regards -- Andy
>>
>>
>>
>> --
>> J=E9r=F4me Martin
>>
>=20
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
