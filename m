From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: [PATCH] st: Destroy st_index_idr on module exit
Date: Fri, 10 Jul 2015 15:42:42 +0300
Message-ID: <4D754493-C926-4E96-83A6-658EA01AA7A5@kolumbus.fi>
References: <1436369041-31156-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs18.mail.saunalahti.fi ([62.142.117.199]:54755 "EHLO
	vs18.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149AbbGJMmt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jul 2015 08:42:49 -0400
In-Reply-To: <1436369041-31156-1-git-send-email-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


> On 8.7.2015, at 18.24, Johannes Thumshirn <jthumshirn@suse.de> wrote:
>=20
> Destroy st_index_idr on module exit, reclaiming the allocated memory.
>=20
> This was detected by the following semantic patch (written by Luis Ro=
driguez
> <mcgrof@suse.com>)
>=20
=2E..
>=20
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

Acked-by: Kai M=C3=A4kisara <kai.makisara@kolumbus.fi>

Thanks,
Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
