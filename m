From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] SCSI: remove noop in fc_remote_port_add()
Date: Fri, 1 Oct 2010 10:26:23 +0800
Message-ID: <AANLkTim7Y_yDBEoCan_hZYLQ98vGMQUNiw4F7R0kq6hF@mail.gmail.com>
References: <AANLkTik-pmP9_ovxiX+SBD2AvxtsWbtj2F-RJbL3w+AY@mail.gmail.com>
	<4CA0433C.8070301@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35627 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab0JAC0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Sep 2010 22:26:25 -0400
Received: by wwj40 with SMTP id 40so719017wwj.1
        for <linux-scsi@vger.kernel.org>; Thu, 30 Sep 2010 19:26:23 -0700 (PDT)
In-Reply-To: <4CA0433C.8070301@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "James E.J. Bottomley" <James.Bottomley@suse.de>

On Mon, Sep 27, 2010 at 3:09 PM, Hannes Reinecke <hare@suse.de> wrote:
> Hillf Danton wrote:
>> For a deleted scsi target marked as FC_PORTSTATE_BLOCKED, =C2=A0resc=
anning
>> it looks fine.
>>
> Note that there has been an earlier patch by Christof Schmitt, which
> does exactly the same thing plus a slightly more in-depth analysis.
> Check for 'scsi: Remove QUEUE_FLAG_REENTER from SCSI code'.
>
What is patched by Christof Schmitt looks better, and
it seems that the queue flag should not be touched outside block core.

> James, comments?
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 zSeries & Storage
> hare@suse.de =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
