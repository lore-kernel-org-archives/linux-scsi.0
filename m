From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RESEND] [PATCH] [SCSI] libsas: Allow expander T-T attachments
Date: Thu, 22 Sep 2011 10:41:50 -0700
Message-ID: <CAA9_cmfy0yttyAXZmY=MubRKOqT+uOescR=+J=y5jc_KfPbA8Q@mail.gmail.com>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com>
	<1316691000.10571.6.camel@dabdike>
	<1316709696.61028.YahooMailNeo@web31812.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46129 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab1IVRlv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2011 13:41:51 -0400
In-Reply-To: <1316709696.61028.YahooMailNeo@web31812.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Thu, Sep 22, 2011 at 9:41 AM, Luben Tuikov <ltuikov@yahoo.com> wrote:
> Allow expander table-to-table attachments for
> expanders that support it.
>
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>

Acked-by: Dan Williams <dan.j.williams@intel.com>

...and can we tag this for -stable.  It meets the 100 line count and
"New device IDs and quirks are also accepted." constraints.
