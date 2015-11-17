From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: [PATCH] [SCSI] st: Remove obsolete scsi_tape.max_pfn
Date: Tue, 17 Nov 2015 21:59:08 +0200
Message-ID: <B0A34A04-67CB-431A-9C0F-B6E807670849@kolumbus.fi>
References: <1447588113-21117-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0 (Mac OS X Mail 9.1 \(3096.5\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs15.mail.saunalahti.fi ([62.142.117.202]:39736 "EHLO
	vs15.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbbKQT7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2015 14:59:14 -0500
In-Reply-To: <1447588113-21117-1-git-send-email-geert@linux-m68k.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


> On 15.11.2015, at 13.48, Geert Uytterhoeven <geert@linux-m68k.org> wr=
ote:
>=20
> Its last user was removed 10 years ago, in commit
> 8b05b773b6030de5 ("[SCSI] convert st to use scsi_execute_async").
>=20
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Kai M=C3=A4kisara <kai.makisara@kolumbus.fi>

Thanks,
Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
