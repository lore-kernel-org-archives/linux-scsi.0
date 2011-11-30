From: Huajun Li <huajun.li.lee@gmail.com>
Subject: Re: [PATCH] SCSI/sd: Fix NULL dereference in sd_revalidate_disk
Date: Wed, 30 Nov 2011 22:50:15 +0800
Message-ID: <CA+v9cxaZRADdjkou9QSgbdCVkgZ=dgG6tTE1cLQOEnN1gh3O_A@mail.gmail.com>
References: <CA+v9cxbk0p_FTDq7TMEc5draOMz4n46H4t=iLe2brkosM=LHVw@mail.gmail.com>
	<20111126105146.756a122a@stein>
	<1322316009.5069.4.camel@dabdike.int.hansenpartnership.com>
	<CA+v9cxa+VbY6Oh800rHKjNQQL-zzk4jE8EUfKeamDgfuc800iw@mail.gmail.com>
	<CA+v9cxZCaz6JguvsqRsxVpx+Jqfg4QBBd1mqqTP0vRjo8na0og@mail.gmail.com>
	<1322361506.5069.20.camel@dabdike.int.hansenpartnership.com>
	<CA+v9cxYVJm1OwbBcctaeBE2Grfouh5tfYU6VD+Qhr2THkBG8Xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53410 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab1K3OuR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2011 09:50:17 -0500
Received: by bkas6 with SMTP id s6so961011bka.19
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2011 06:50:16 -0800 (PST)
In-Reply-To: <CA+v9cxYVJm1OwbBcctaeBE2Grfouh5tfYU6VD+Qhr2THkBG8Xg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Huajun Li <huajun.li.lee@gmail.com>

> Not exactly. It happens if =A0->open returns zero or -ENOMEDIUM, plea=
se
> see this commit:
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dco=
mmitdiff;h=3D1196f8b814f32cd04df334abf47648c2a9fd8324
>
Sorry, I should remove my word "Not exxxxx" ..
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
