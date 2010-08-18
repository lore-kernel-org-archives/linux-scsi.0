From: Chetan Loke <chetanloke@gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Wed, 18 Aug 2010 12:04:13 -0400
Message-ID: <AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
	<1282144271.3035.31.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34743 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab0HRQEO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2010 12:04:14 -0400
In-Reply-To: <1282144271.3035.31.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Chetan Loke <generationgnu@yahoo.com>, Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Aug 18, 2010 at 11:11 AM, James Bottomley
<James.Bottomley@suse.de> wrote:
> The decision hasn't been taken to merge LIO, but based on what happened
> at the summit, I think it's the most viable candidate and will likely be
> merged by 2.6.37
>

During the open panel, facebook guys and others were tooting that
start-ups thrive because they can hack linux. Well there are quite a
few start-ups that use scst too for creating target appliances.
Has anyone even bothered to glance the scst mailing list to see if
that community is dead or alive?

I for one use scst to create synthetic work-loads and test 200+ VM
nodes in an ESX cluster. Anyone who has worked on a SAN OS will
appreciate the simplicity of SCST. And if folks still can't understand
the SCST code(after reading the README) then they are still welcome to
send an email on SCST. Would you like to make your FC stack go faster,
well please drop us an email on SCST and we will try our best to
further optimize the FC driver.

I know folks who don't understand simple DMA bus traces, FC wire
traces and yet they have the power to influence decisions.

James you are an expert but not everyone is. This is not a venting
session but even folks who are new to target architecture find it easy
to hack SCST.


>> As a scst-user what I would like to understand is, what was that
>> decision based on? Because the LSF summit was 'small by invitation'
>> only summit. The notes don't give us an insight on the selection
>> criteria/merits etc.
>
> The notes list 3, what's unclear about it?

Sorry, my bad. I sent an email earlier. I was trying to access a different link.


>> > > 3. I have heard you said "Vlad wasn't comfortable in
>> > handing up the
>> > > control to the maintainers ... (this is how kernel.org
>> > works)." I have
>> > > no idea what you meant. I have never been asked about
>> > anything like
>> > > that, so I couldn't say anyhow that I'm not
>> > comfortable with anything.
>> > > Could you clarify that?
>> > >
>>
>> 3) above is something that I emailed Vlad and the scst community based
>> on our offline conversation after the open panel. If SCST really has
>> licensing issues then I will personally stop using SCST. Since Vlad
>> hasn't
>> expressed any concerns on the above and neither have you commented on
>> it, is it safe to assume that the licensing requirement is a
>> non-issue?
>
> No.
>

huh? It's dual licensed. GPL and BSD(if I'm not wrong).


> James

--cloke
