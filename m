From: stevec <stephenmcameron@gmail.com>
Subject: Re: Add hpsa driver for HP Smart Array controllers.
Date: Sat, 3 Oct 2009 06:22:21 -0700 (PDT)
Message-ID: <b4c460e2-0e83-415a-b3ef-4b95188e5de4@o21g2000vbl.googlegroups.com>
References: <dqBnV-3pF-5@gated-at.bofh.it> <dqWVs-3hD-15@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f142.google.com ([209.85.211.142]:39454 "EHLO
	mail-yw0-f142.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211AbZJCOHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Oct 2009 10:07:10 -0400
In-Reply-To: <dqWVs-3hD-15@gated-at.bofh.it>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com

On Oct 2, 4:30=A0pm, Rolf Eike Beer <eike-ker...@sf-tec.de> wrote:
> Stephen M. Cameron wrote:
> > +static const char *raid_label[] =3D { "0", "4", "1(1+0)", "5", "5+=
1", "ADG",
> > + =A0"UNKNOWN"
> > +};
> > +#define RAID_UNKNOWN (sizeof(raid_label) / sizeof(raid_label[0]) -=
 1)
>
> (ARRAY_SIZE(raid_label) - 1)
>
>
[...]

Thanks for the feedback.

-- steve

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
