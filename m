From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] [SCSI] libsas: Allow expander T-T attachments
Date: Tue, 20 Sep 2011 17:50:42 -0700
Message-ID: <CAA9_cme=OUJcQB+GaJVWSvkg1ha7cmqotuMeZiRda1hzODHuOg@mail.gmail.com>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com>
	<1311839519.30253.16.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42597 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab1IUAuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Sep 2011 20:50:44 -0400
In-Reply-To: <1311839519.30253.16.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@us.xyratex.com>

On Thu, Jul 28, 2011 at 12:52 AM, James Bottomley
<jbottomley@parallels.com> wrote:
> On Wed, 2011-07-27 at 21:19 -0700, Luben Tuikov wrote:
>> Allow expander table-to-table attachments for
>> expanders that support it.
>
> This is half the code to do SAS 2.0 expanders. =A0You seem to have
> additions from the other half (self configuring expanders) see below;
> does this mean you have a patch for self configuring expanders in the
> works?

I'd like to see that as well, but in the meantime support for the
other SAS-2 fields does not block basic operation like the lack of
table-to-table support does.

Can we also tag this for -stable?  It's akin to a pci device id update
in terms of impact.

Acked-by: Dan Williams <dan.j.williams@intel.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
