From: Jerome Martin <jxm@risingtidesystems.com>
Subject: Re: target userspace utils (rtsadmin) project is dysfunctional
Date: Sun, 11 Sep 2011 08:37:04 +0300
Message-ID: <CAN4SboA8z1drZxbs0CtKPLtQ+n4bY0UqrRSVt_ZB-4TgdBKtBA@mail.gmail.com>
References: <4E69BB29.2030800@redhat.com>
	<CAN4SboCi7C9iB+GNH85yfMkvDQdf4BN4CunUuJjvc+a-cfaCFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44733 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab1IKFhF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2011 01:37:05 -0400
In-Reply-To: <CAN4SboCi7C9iB+GNH85yfMkvDQdf4BN4CunUuJjvc+a-cfaCFQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Nicholas Bellinger <nab@risingtidesystems.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Repost including target-devel and linux-scsi lists.
Sorry for the noise.

On Sat, Sep 10, 2011 at 10:30 PM, Jerome Martin
<jxm@risingtidesystems.com> wrote:
> Hi Andy,
> I am not so much interested in your "calculation" than on having a li=
st of
> checkpoints that you feel would be important to improve in order to h=
ave a
> better OSS project. In all good faith, I can assure you this is all I=
 (we)
> are looking for, within the limits of time & resources available.
> As for the emails I did not (never, really ?) answer, apart from the
> vacation pointed out by Nic, I guess I must have erased part of my ma=
ilbox
> inadvertently then, because I do not have them in my todo box, in whi=
ch I
> normally have everything not handled yet.
>
> Anyway, thanks for saying rtsadmin is a nice piece of code, I hope we=
 can
> improve it with as much enlightened (read from people using it ;-) ) =
input
> as possible.
> And again, I really am eager to take your suggestions about how to im=
prove
> the docs and processes, these are vast topics and the best places to =
start
> might not be always intuitive when you are deep into the code itself.=
 I
> engaged huge efforts in making rtsadmin self-documenting as possible,=
 with a
> lot of documentation in the code itself, but clearly this is not enou=
gh. I
> assume there might be some easy to do pieces of doc that could improv=
e
> dramatically the user experience, but am unsure what they are (instal=
l ?
> packaging ? building from source ? quickstart ? so many things to do.=
=2E.).
> As for what's planned, the next items on my community todo are to ada=
pt the
> build process to export a versioned tarball so distros and everyone e=
lse can
> get a fixed version release without having to go through the git-depe=
ndent
> build process, fix the tags exports to the community repository (some=
 script
> is blocking somewhere in the chain of autocommits) and write a quick =
"how to
> build packages" howto. Do those sound reasonable to you or would you =
put
> something higher on the priority list ?
> One last thing I need to say is that the company as a whole as a very
> favorable view of anything that can improve the community experience,=
 so
> every misimplementation of that policy is to blame on me. Unfortunate=
ly I
> might have a hard time managing priorities and workload, and this app=
arently
> led to regrettable effects on the OSS project.
> Thanks for both the kind and critical words, but now you've said too =
much to
> withhold the constructive mentoring any longer ;-)
> Kind Regards,
> Jerome
> On Fri, Sep 9, 2011 at 10:07 AM, Andy Grover <agrover@redhat.com> wro=
te:
>>
>> Hi Jerome and Nick,
>>
>> I happened upon this website:
>>
>>
>> http://www.theopensourceway.org/book/The_Open_Source_Way-How_to_tell=
_if_a_FLOSS_project_is_doomed_to_FAIL.html
>>
>> According to my calculations (available upon request), rtsadmin come=
s in
>> at 220 points: "so much fail, your code should have its own reality =
TV
>> show".
>>
>> I could also add some more like "primary developer never responds to
>> email", "CLA discourages external contributions", and "uses executab=
le
>> name as corporate marketing tool".
>>
>> Admittedly rtsadmin is a nice piece of code, thanks btw, but your
>> company is falling short of accepted standards for stewardship of a
>> FLOSS project. Please tell me why we all wouldn't be better off if I
>> forked rtsadmin tomorrow.
>>
>> Regards -- Andy
>
>
>
> --
> J=E9r=F4me Martin
>



--=20
J=E9r=F4me Martin
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
