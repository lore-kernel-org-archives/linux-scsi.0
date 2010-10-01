From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] SCSI: remove noop in fc_bsg_goose_queue()
Date: Fri, 1 Oct 2010 10:30:25 +0800
Message-ID: <AANLkTi=DFP+fTz-beF3prwur-X8jWRptRjhsSFDe9tsn@mail.gmail.com>
References: <AANLkTi=LeDERNV8ij6Jj+Z5cT8PRhd+4UqyzBRiBRcP+@mail.gmail.com>
	<1285083682.16440.36.camel@mulgrave.site>
	<AANLkTi=mcETa6FfUCE9=J2_m1dS31UTBCdu5i76CAd+F@mail.gmail.com>
	<1285541913.2888.71.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:33374 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab0JACcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Sep 2010 22:32:03 -0400
Received: by wwi18 with SMTP id 18so599406wwi.1
        for <linux-scsi@vger.kernel.org>; Thu, 30 Sep 2010 19:31:01 -0700 (PDT)
In-Reply-To: <1285541913.2888.71.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Mon, Sep 27, 2010 at 6:58 AM, James Bottomley
<James.Bottomley@suse.de> wrote:
> Think about it ... it's clearly something to do with the flag ... wha=
t
> is it? =C2=A0Google is useful as well as looking in the block source =
code.
> The key would be knowing what the flag does.
>
> James
>
node.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
