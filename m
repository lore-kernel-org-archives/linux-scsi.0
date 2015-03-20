From: Christian Hesse <list@eworm.de>
Subject: Re: iSCSI regression with linux 3.9 and 4.0
Date: Fri, 20 Mar 2015 15:31:04 +0100
Message-ID: <20150320153104.086f3b46@leda.localdomain>
References: <20150320135742.63df219b@leda.localdomain>
	<1426859486.19806.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_//A0FI7fYsjNJ85X+Ar/TmHP"; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.mylinuxtime.de ([148.251.109.235]:59118 "EHLO
	mx.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbbCTObL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Mar 2015 10:31:11 -0400
In-Reply-To: <1426859486.19806.30.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ewan Milne <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

--Sig_//A0FI7fYsjNJ85X+Ar/TmHP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Ewan Milne <emilne@redhat.com> on Fri, 2015/03/20 09:51:
> On Fri, 2015-03-20 at 13:57 +0100, Christian Hesse wrote:
> > Hello everybody!
> >=20
> > I reported this issue at LKML [0] but received no answer. Hopefully
> > linux-scsi is a better place...
> >=20
> > Beginning with linux 3.19 I see an iSCSI regressen. This works perfectly
> > with linux 3.18.x (tested with 3.18.6) and before. Effected kernels I
> > tested are 3.19.0, 3.19.2 and 4.0rc4.r199.gb314aca.
> >=20
> > The logs tell the story:
> >=20
> > Feb 19 11:26:49 thebe kernel: scsi host6: iSCSI Initiator over TCP/IP
> > Feb 19 11:26:49 thebe kernel: scsi 6:0:0:0: Direct-Access     QNAP
> > iSCSI Storage    4.0  PQ: 0 ANSI: 5 Feb 19 11:26:49 thebe kernel: sd
> > 6:0:0:0: [sdb] 1073741824 512-byte logical blocks: (549 GB/512 GiB) Feb
> > 19 11:26:49 thebe kernel: sd 6:0:0:0: [sdb] Write Protect is off Feb 19
> > 11:26:49 thebe kernel: sd 6:0:0:0: [sdb] Mode Sense: 2f 00 00 00 Feb 19
> > 11:26:49 thebe kernel: sd 6:0:0:0: [sdb] Write cache: disabled, read
> > cache: enabled, doesn't support DPO or FUA Feb 19 11:26:49 thebe kernel:
> > sdb: unknown partition table Feb 19 11:26:49 thebe kernel: sd 6:0:0:0:
> > [sdb] Attached SCSI disk Feb 19 11:26:49 thebe iscsid[10804]:
> > Connection1:0 to [target:
> > iqn.2004-04.com.qnap:ts-859:iscsi.xxxxxxx.c40a18, portal:
> > xx.xx.xx.xx,3260] through [iface: default] is operational now Feb 19
> > 11:26:57 thebe kernel:  sdb: unknown partition table Feb 19 11:28:20
> > thebe kernel: EXT4-fs (dm-8): mounting with "discard" option, but the
> > device does not support discard Feb 19 11:28:20 thebe kernel: EXT4-fs
> > (dm-8): mounted filesystem with ordered data mode. Opts: (null) Feb 19
> > 11:28:24 thebe kernel: sd 6:0:0:0: [sdb] UNKNOWN Result: hostbyte=3D0x00
> > driverbyte=3D0x08 Feb 19 11:28:24 thebe kernel: sd 6:0:0:0: [sdb] Sense
> > Key : 0x5 [current] Feb 19 11:28:24 thebe kernel: sd 6:0:0:0: [sdb]
> > ASC=3D0x24 ASCQ=3D0x0 Feb 19 11:28:24 thebe kernel: sd 6:0:0:0: [sdb] C=
DB:
> > Feb 19 11:28:24 thebe kernel: cdb[0]=3D0x2a: 2a 00 34 5b 07 ff 00 2f 88=
 00
> > Feb 19 11:28:24 thebe kernel: blk_update_request: critical target error,
> > dev sdb, sector 878381055 Feb 19 11:28:24 thebe kernel: EXT4-fs warning
> > (device dm-8): ext4_end_bio:317: I/O error -121 writing to inode 331965=
03
> > (offset 8388608 size 7278592 starting block 108749056) Feb 19 11:28:24
> > thebe kernel: Buffer I/O error on device dm-8, logical block 108749056
> > Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical
> > block 108749057 Feb 19 11:28:24 thebe kernel: Buffer I/O error on device
> > dm-8, logical block 108749058 Feb 19 11:28:24 thebe kernel: Buffer I/O
> > error on device dm-8, logical block 108749059 Feb 19 11:28:24 thebe
> > kernel: Buffer I/O error on device dm-8, logical block 108749060 Feb 19
> > 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical block
> > 108749061 Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8,
> > logical block 108749062 Feb 19 11:28:24 thebe kernel: Buffer I/O error =
on
> > device dm-8, logical block 108749063 Feb 19 11:28:24 thebe kernel: Buff=
er
> > I/O error on device dm-8, logical block 108749064 Feb 19 11:28:24 thebe
> > kernel: Buffer I/O error on device dm-8, logical block 108749065 Feb 19
> > 11:28:24 thebe kernel: EXT4-fs warning (device dm-8): ext4_end_bio:317:
> > I/O error -121 writing to inode 33196503 (offset 8388608 size 7278592
> > starting block 108749312) Feb 19 11:28:24 thebe kernel: EXT4-fs warning
> > (device dm-8): ext4_end_bio:317: I/O error -121 writing to inode 331965=
03
> > (offset 8388608 size 7278592 starting block 108749568) Feb 19 11:28:24
> > thebe kernel: EXT4-fs warning (device dm-8): ext4_end_bio:317: I/O error
> > -121 writing to inode 33196503 (offset 8388608 size 7278592 starting
> > block 108749824) Feb 19 11:28:24 thebe kernel: EXT4-fs warning (device
> > dm-8): ext4_end_bio:317: I/O error -121 writing to inode 33196503 (offs=
et
> > 8388608 size 7278592 starting block 108750080) Feb 19 11:28:24 thebe
> > kernel: EXT4-fs warning (device dm-8): ext4_end_bio:317: I/O error -121
> > writing to inode 33196503 (offset 8388608 size 7278592 starting block
> > 108750336) Feb 19 11:29:10 thebe kernel: sd 6:0:0:0: [sdb] UNKNOWN
> > Result: hostbyte=3D0x00 driverbyte=3D0x08 Feb 19 11:29:10 thebe kernel:=
 sd
> > 6:0:0:0: [sdb] Sense Key : 0x5 [current] Feb 19 11:29:10 thebe kernel: =
sd
> > 6:0:0:0: [sdb] ASC=3D0x24 ASCQ=3D0x0 Feb 19 11:29:10 thebe kernel: sd
> > 6:0:0:0: [sdb] CDB: Feb 19 11:29:10 thebe kernel: cdb[0]=3D0x2a: 2a 00 =
20
> > 44 89 17 00 20 50 00 Feb 19 11:29:10 thebe kernel: blk_update_request:
> > critical target error, dev sdb, sector 541362455 Feb 19 11:29:10 thebe
> > kernel: Buffer I/O error on dev dm-8, logical block 66621731, lost sync
> > page write Feb 19 11:29:10 thebe kernel: Aborting journal on device
> > dm-8-8. Feb 19 11:29:10 thebe kernel: EXT4-fs error (device dm-8):
> > ext4_journal_check_start:56: Detected aborted journal Feb 19 11:29:10
> > thebe kernel: EXT4-fs (dm-8): Remounting filesystem read-only Feb 19
> > 11:29:20 thebe kernel: EXT4-fs error (device dm-8): ext4_put_super:780:
> > Couldn't clean up the journal
> >=20
> > [0] https://lkml.org/lkml/2015/2/19/91
>=20
> Sense key 0x5 ASC/ASCQ 0x24 0x00 is ILLEGAL REQUEST, INVALID FIELD IN
> CDB.  The CDB was 2A 00 34 5B 07 FF 00 2F 88 00, which is a WRITE_10
> to LBA 878381055 with a length of 12168 blocks (a little less than 6MB).
> It looks like this is within the reported capacity of the device, and
> there are no other bits set in the CDB.
>=20
> Looks like you could get this error if RWWP (reject without write
> protection) is set in the control mode page.  I don't see any messages
> about the protection type, though.  What does sysfs report?

Is that what you are interested in?

# cat protection_mode protection_type=20
none
0

In case it matters: The iSCSI device is LUKS encrypted, that is why device
mapper shows up.

I removed the discard option from filesystem's default mount option, but
that brings no difference except the message is not printed.
--=20
main(a){char*c=3D/*    Schoene Gruesse                         */"B?IJj;MEH"
"CX:;",b;for(a/*    Chris           get my mail address:    */=3D0;b=3Dc[a+=
+];)
putchar(b-1/(/*               gcc -o sig sig.c && ./sig    */b/42*2-3)*42);}

--Sig_//A0FI7fYsjNJ85X+Ar/TmHP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVDC8oAAoJEIlFIdfMgPR27xMIAJePR5ht6rDvMKnkLlcIcP+c
ZMfg+SHIufPLyXBa/l0Fl0XpZi+wZXOBlaHmUmG/mlscU+Ij+0smSzYjcGFseljY
vhVTjj7rgibQVzJkJ2UCq95R6FdBkPr9ukzDdXFqmDgrNjGVbaGJZgJMDrMXsWWL
LTB1Qd2t33u80D2ZcRxQ/IpEhaloqXeRmd6y2pAedf2ZtNgjml6kYlMyNaa5ov+y
NhnpPtPzgkPCvCXQyuqLkvDhhPZvVXVbWKH4hPa8cfP0JKm0KZWX2drgQAadkVew
yNMqw+9wOlfd3ut1M/VAIL340UaHd8YONNNfOQMBr5rkXlLp4EixewEo5uSfRHI=
=nosb
-----END PGP SIGNATURE-----

--Sig_//A0FI7fYsjNJ85X+Ar/TmHP--
