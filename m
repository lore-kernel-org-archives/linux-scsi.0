From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] SCSI: remove noop in fc_bsg_goose_queue()
Date: Thu, 23 Sep 2010 23:10:32 +0800
Message-ID: <AANLkTi=mcETa6FfUCE9=J2_m1dS31UTBCdu5i76CAd+F@mail.gmail.com>
References: <AANLkTi=LeDERNV8ij6Jj+Z5cT8PRhd+4UqyzBRiBRcP+@mail.gmail.com>
	<1285083682.16440.36.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42312 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab0IWPKe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Sep 2010 11:10:34 -0400
Received: by wwd20 with SMTP id 20so65868wwd.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Sep 2010 08:10:33 -0700 (PDT)
In-Reply-To: <1285083682.16440.36.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Tue, Sep 21, 2010 at 11:41 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
>
> this code doesn't do anything because there's a bug in it. =C2=A0If y=
ou can
> work out what it's trying to do, you should be able to fix the bug.
>
> James
>
What is it, James? Because I could not goto deep sleep with this bug in=
 ear.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
