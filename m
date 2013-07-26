From: Marc Fleischmann <mwf@daterainc.com>
Subject: RE: targetcli -fb now also Apache 2.0 licensed
Date: Fri, 26 Jul 2013 08:18:22 -0700
Message-ID: <214513e90ef73562cf875225c3bd60ed@mail.gmail.com>
References: <51EF73EF.1040305@redhat.com>  <1374696565.7397.1292.camel@haakon3.risingtidesystems.com>
  <1374697264.7382.39.camel@dabdike>  <1374699289.7397.1309.camel@haakon3.risingtidesystems.com>
  <51F06C17.50306@redhat.com> <1374715140.7397.1390.camel@haakon3.risingtidesystems.com>
 <51F1ED9D.50300@redhat.com> <51F22425.6000801@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:51387 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366Ab3GZPSa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jul 2013 11:18:30 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so2933190wgg.0
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2013 08:18:29 -0700 (PDT)
In-Reply-To: <51F22425.6000801@debian.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rrs@debian.org, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, targetcli-fb-devel@lists.fedorahosted.org, linux-kernel <linux-kernel@vger.kernel.org>

Ritesh,

We have put immense labor and love in creating LIO and targetcli. Please
just take a look at the code, the wiki, the manual, target-devel - we have
poured years of our lives into this project, and we look forward to
implementing many more exciting ideas. Asking us to just abandon this is -
simply absurd. Of course, we'll continue to maintain one coherent software
stack with extensive documentation (we'd love contributions here, too!)
and provide support for all of it through a well-known forum
(target-devel).

If Andy prefers not helping us to pull his few changes upstream, we'll
gladly just do it ourselves.

Best regards,

Marc Fleischmann
DATERA | 650.384.6366 | @dateranews

-----Original Message-----
From: target-devel-owner@vger.kernel.org
[mailto:target-devel-owner@vger.kernel.org] On Behalf Of Ritesh Raj Sarraf
Sent: Friday, July 26, 2013 12:24 AM
To: target-devel; linux-scsi
Cc: Andy Grover; Nicholas A. Bellinger; James Bottomley;
targetcli-fb-devel@lists.fedorahosted.org; linux-kernel
Subject: Re: targetcli -fb now also Apache 2.0 licensed

On Friday 26 July 2013 09:01 AM, Andy Grover wrote:
>
> It's one thing to claim a prerogative of "upstream", but for this to
> make sense, there needs to be an actual community around the upstream.
> And if there's going to be submissions for review, then there needs to
> be someone in charge of the community with a high degree of skill in
> the code base. Nick you have a great deal of technical expertise
> around the C code in drivers/target, but Jerome was the one who wrote
> rtslib, targetcli, and configshell. I believe you can assess the
> technical aspects of how the user library interacts with the kernel
> code, but the maintainer should also be extremely conversant in the
> language the library is written in. In this case, Python. So it's not
> clear to me if submitting the code would actually result in meaningful
> code improvements.
>
> Also, there has been no effort to sustain a community around this
> code. There is no bug tracking, no separate mailing list, no regular
> releases. Debian is running ancient, broken code because nothing's
> been tagged in over two years.
>
> I would love to have you maintain and improve this code, but if you
> aren't then you can't just say "I'm the upstream bow to me!". We're
> shipping this code in Fedora and it needs active maintenance. Now that
> we're all on an even licensing footing, code can flow both ways, and
> even into your commercial version.

Yes. Apart from reaching out the developers directly, I am not aware of
other communication channels. There is a git and wiki though.

Nick, if you guys have the same license now, nothing should stop you to
pull the changes from the targetcli-fb repo. You can start afresh now and
comply with what the community guidelines are. Licensing is just one part
of it.

And regarding this whole licensing dispute in the open, the kernel
maintainers should have resolved this long ago, when it was decided to
have LIO as the in-kernel target for Linux.
You might say that the target component complied by the kernel's licensing
requirements. But for a subsystem inclusion, you don't look just at the
code, but also the maintainer. Their support tools. And their long term
plans. These rules have been applied, in the past, for other features in
the kernel.

--
Ritesh Raj Sarraf | http://people.debian.org/~rrs Debian - The Universal
Operating System
