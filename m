From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: /dev/[*]st* does not work with EXBAYTE 8505 with 2.6 kernels
Date: Thu, 26 Aug 2004 00:18:32 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0408260015100.1974@kai.makisara.local>
References: <412C315D.1000708@hovedpuden.dk>    <Pine.LNX.4.58.0408252225550.1974@kai.makisara.local>
 <28477.192.48.171.17.1093467320.squirrel@192.48.171.17>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep07-0.kolumbus.fi ([193.229.0.51]:64230 "EHLO
	fep07-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S268991AbUHYVSd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2004 17:18:33 -0400
In-Reply-To: <28477.192.48.171.17.1093467320.squirrel@192.48.171.17>
List-Id: linux-scsi@vger.kernel.org
To: John Damm =?iso-8859-1?Q?S=F8rensen?= <john@hovedpuden.dk>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

On Wed, 25 Aug 2004, John Damm S=F8rensen wrote:

=2E..
> > If you look at the kernel messages, do you see something like this:
> >
> > st: Version 20040403, fixed bufsize 32768, s/g segs 256
> > Attached scsi tape st0 at scsi0, channel 0, id 5, lun 0
> > st0: try direct i/o: yes (alignment 512 B), max page reachable by H=
BA
> > 268435455
>=20
> Yes, I see this message in dmesg.
>=20
OK, st has attached the drive.

=2E..
> With 2.6 the tape  drive fails to work with the Qlogic HBA's ISP1040 =
(the
> HBA simply doesn't work with 2.6) and QLA12160, but it works with the
> Symbios/LSI HBA.
>=20
So, the problem is specific to the Qlogic adapters. Do you see any SCSI=
=20
error messages? (When st has attached the drive, the device should be=20
present. If it is offlined by failing SCSI error recovery, the device=20
disappears again.)

--=20
Kai
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
