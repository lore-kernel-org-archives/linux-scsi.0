From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: Add QEMU CD-ROM to VPD Inquiry Blacklist
Date: Tue, 31 May 2016 15:43:35 +0200
Message-ID: <20160531134335.o3jpinkdl3wg7ww2@c203.arch.suse.de>
References: <1464702149-26573-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbcEaNnl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2016 09:43:41 -0400
Content-Disposition: inline
In-Reply-To: <1464702149-26573-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Tue, May 31, 2016 at 09:42:29AM -0400, Ewan D. Milne wrote:
> Linux fails to boot as a guest with a QEMU CD-ROM:
>=20
> [    4.439488] ata2.00: ATAPI: QEMU CD-ROM, 0.8.2, max UDMA/100
> [    4.443649] ata2.00: configured for MWDMA2
> [    4.450267] scsi 1:0:0:0: CD-ROM            QEMU     QEMU CD-ROM  =
    0.8. PQ: 0 ANSI: 5
> [    4.464317] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action =
0x6 frozen
> [    4.464319] ata2.00: BMDMA stat 0x5
> [    4.464339] ata2.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 0=
 dma 16640 in
> [    4.464339]          Inquiry 12 01 00 00 ff 00res 48/20:02:00:24:0=
0/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
> [    4.464341] ata2.00: status: { DRDY DRQ }
> [    4.465864] ata2: soft resetting link
> [    4.625971] ata2.00: configured for MWDMA2
> [    4.628290] ata2: EH complete
> [    4.646670] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action =
0x6 frozen
> [    4.646671] ata2.00: BMDMA stat 0x5
> [    4.646683] ata2.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 0=
 dma 16640 in
> [    4.646683]          Inquiry 12 01 00 00 ff 00res 48/20:02:00:24:0=
0/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
> [    4.646685] ata2.00: status: { DRDY DRQ }
> [    4.648193] ata2: soft resetting link
>=20
> ...
>=20
> Fix this by suppressing VPD inquiry for this device.
>=20
> Reported-by: Jan Stancek <jstancek@redhat.com>
> Tested-by: Jan Stancek <jstancek@redhat.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
