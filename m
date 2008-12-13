From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
Subject: Re: [PATCH][RFC 2/23]: SCST core
Date: Sat, 13 Dec 2008 02:27:44 +0100
Message-ID: <c62985530812121727x6a550028iee111a97cf1536b1@mail.gmail.com>
References: <494009D7.4020602@vlnb.net> <49400ACD.3070502@vlnb.net>
	 <20081210191213.GA15273@uranus.ravnborg.org>
	 <49414DBE.6070801@vlnb.net>
	 <20081211210917.GB27010@uranus.ravnborg.org>
	 <4942BA85.3070408@vlnb.net>
	 <1229118607.24995.18.camel@localhost.localdomain>
	 <20081212230523.GB4775@ghostprotocols.net>
	 <c62985530812121725m19b779d8o2c274efecdca93ab@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:53564 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbYLMB1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Dec 2008 20:27:50 -0500
In-Reply-To: <c62985530812121725m19b779d8o2c274efecdca93ab@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Steven Rostedt <srostedt@redhat.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Sam Ravnborg <sam@ravnborg.org>, linux-scsi@vger.kernel

2008/12/13 Fr=E9d=E9ric Weisbecker <fweisbec@gmail.com>:
> 2008/12/13 Arnaldo Carvalho de Melo <acme@redhat.com>:
>> Steven, is it possible to trigger tracing for any function when a
>> function in the list set up by the user is running and then stop tra=
cing
>> when it exits?
>>
>> - Arnaldo
>>
>
> Hi Arnaldo,
>
> Yes it's possible with ftrace, by using the function graph tracer ( a=
n
> ftrace extension that adds the tracing on return).
>
> To enable it just do:
> echo function_graph > /debugfs/tracing/current_tracer
>
> And to trace by choosing a particular function as the root of the cal=
l
> stack, just do the things
>  explained on this patch:
> http://git.kernel.org/?p=3Dlinux/kernel/git/mingo/linux-2.6-sched-dev=
el.git;a=3Dcommit;h=3Dea4e2bc4d9f7370e57a343ccb5e7c0ad3222ec3c
>
> And the tracing will finish after this function returns :-)
>

I forgot to say that add-on is not yet included on 2.6.28
This will be available for 2.6.29.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
