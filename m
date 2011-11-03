From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/3] scsi: add hooks for host runtime power management
Date: Thu, 3 Nov 2011 07:41:43 -0700
Message-ID: <CAOS58YNNx7XOGov19_hucAQYvw88F2YO+KoVpn8uD+COgJRbEw@mail.gmail.com>
References: <Pine.LNX.4.44L0.1111031019250.2136-100000@iolanthe.rowland.org>
	<1320331063.2813.78.camel@hp6530s>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dy0-f46.google.com ([209.85.220.46]:41678 "EHLO
	mail-dy0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab1KCOlq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2011 10:41:46 -0400
In-Reply-To: <1320331063.2813.78.camel@hp6530s>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, "Huang, Ying" <ying.huang@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>

Hello,

On Thu, Nov 3, 2011 at 7:37 AM, Lin Ming <ming.m.lin@intel.com> wrote:
>> Yes, it is a problem. =A0But it looks like the underlying issue is t=
hat
>> you're using the SCSI error handler to do something it was not inten=
ded
>> for. =A0Can't you suspend and resume the ATA port without using the =
error
>> handler?
>
> The system suspend and resume of the ATA port uses the error handler.
> I think the runtime suspend and resume should use the error handler t=
oo.
>
> Tejun,
>
> Could you comment more on this?

I don't know. I haven't really thought about it but as it's currently
designed, I don't think it'll be possible to avoid going through EH to
put ATA ports into suspend mode.

Thanks.

--=20
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
