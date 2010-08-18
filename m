From: Chetan Loke <chetanloke@gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Wed, 18 Aug 2010 13:51:07 -0400
Message-ID: <AANLkTimYZOyRv8u8bqNPRMseBcboSuJAWjtwo5MQCSQR@mail.gmail.com>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
	<1282144271.3035.31.camel@mulgrave.site>
	<AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>
	<1282148296.3035.49.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1282148296.3035.49.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Chetan Loke <generationgnu@yahoo.com>, Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 18, 2010 at 12:18 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Wed, 2010-08-18 at 12:04 -0400, Chetan Loke wrote:
>> On Wed, Aug 18, 2010 at 11:11 AM, James Bottomley
>> <James.Bottomley@suse.de> wrote:
>> > The decision hasn't been taken to merge LIO, but based on what hap=
pened
>> > at the summit, I think it's the most viable candidate and will lik=
ely be
>> > merged by 2.6.37
>> >
>>
>> During the open panel, facebook guys and others were tooting that
>> start-ups thrive because they can hack linux. Well there are quite a
>> few start-ups that use scst too for creating target appliances.
>> Has anyone even bothered to glance the scst mailing list to see if
>> that community is dead or alive?
>>
>> I for one use scst to create synthetic work-loads and test 200+ VM
>> nodes in an ESX cluster. Anyone who has worked on a SAN OS will
>> appreciate the simplicity of SCST. And if folks still can't understa=
nd
>> the SCST code(after reading the README) then they are still welcome =
to
>> send an email on SCST. Would you like to make your FC stack go faste=
r,
>> well please drop us an email on SCST and we will try our best to
>> further optimize the FC driver.
>>
>> I know folks who don't understand simple DMA bus traces, FC wire
>> traces and yet they have the power to influence decisions.
>>
>> James you are an expert but not everyone is. This is not a venting
>> session but even folks who are new to target architecture find it ea=
sy
>> to hack SCST.
>


> But that's not really relevant, is it? =C2=A0I would expect that what=
ever I
> do, even keeping both out of tree, the communities around the solutio=
ns
> would still exist and be vibrant, since they're out of tree now, noth=
ing
> will have changed.
>

Of course it's relevant. Not all engineers know about everything when
they venture in a new area. SCST overcomes that. It's not
intimidating. Infact, 3 months back, I asked a storport/miniport(aka
Windows) guy to take a look at scst and after studying the README he
was amazed to see how easy it was. Plus,everyone knows that if a
solution is inbox then it's just easier to maintain. Also no need to
patch/re-spin my iso. And you are missing the point - find me one good
technical conversation thread on LIO! What does that tell you? Why not
give a chance(or atleast consider?) to someone who has a wide/active
user base?

LIO never struggled to push their code upstream and it still is a
viable candidate? On the other hand scst users/developers are ready to
bend over to accommodate all the changes! What does that tell you?

James, how can a community remain vibrant when one solution is
favoured over another w/o any clear explanation and justification?
It's like the old saying - the lips are moving but all I hear is blah
blah blah. We look up to you but why should we accept the outcome of a
closed door LSF session ;)?


> James
-- cloke
