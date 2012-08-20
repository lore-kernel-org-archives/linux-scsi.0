From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [patch 0/5] st: Clean up and raise max device limit (v4)
Date: Mon, 20 Aug 2012 22:55:47 +0300 (EEST)
Message-ID: <alpine.LNX.2.00.1208202252480.5250@kai.makisara.local>
References: <20120818192036.751334179@suse.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811327-197311338-1345492556=:5250"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs18.mail.saunalahti.fi ([62.142.117.199]:49600 "EHLO
	vs18.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab2HTTz6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Aug 2012 15:55:58 -0400
In-Reply-To: <20120818192036.751334179@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Mahoney <jeffm@suse.de>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Lee Duncan <lduncan@suse.com>, Rob Evers <revers@redhat.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811327-197311338-1345492556=:5250
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 18 Aug 2012, Jeff Mahoney wrote:

> This patchset cleans up the SCSI tape device handling code and leverage=
s it
> to lift the limitation of the number of tape drives from the previous
> arbitrary limit of 128 to the maximum supported by a device node that
> creates 8 character devices per physical device. Since minors are 20 bi=
ts,
> that means 2^17 tape drives can be supported.
>=20
> Changed in this version: A previous revision introduced a regression wh=
ere
> tape drives would not be shown as tape devices in lsscsi. This was due =
to
> the missing "tape" symlink in sysfs. That issue has been addressed and
> lsscsi works properly again. Also, it passes checkpatch with no errors.
>=20
> Please apply.
>=20
The whole series (1-5):

Acked-by: Kai M=C3=A4kisara <kai.makisara@kolumbus.fi>

Thanks,
Kai
---1463811327-197311338-1345492556=:5250--
