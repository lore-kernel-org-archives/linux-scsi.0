From: Christian Hesse <list@eworm.de>
Subject: Re: iSCSI regression with linux 3.9 and 4.0
Date: Mon, 23 Mar 2015 09:53:08 +0100
Message-ID: <20150323095308.196dd451@leda.localdomain>
References: <20150320135742.63df219b@leda.localdomain>
	<1426859486.19806.30.camel@localhost.localdomain>
	<20150320153104.086f3b46@leda.localdomain>
	<1426863883.19806.65.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/VMAkbbRv3yY6kZKT6f+FoPG"; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.mylinuxtime.de ([148.251.109.235]:35623 "EHLO
	mx.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbbCWIxP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Mar 2015 04:53:15 -0400
In-Reply-To: <1426863883.19806.65.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ewan Milne <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

--Sig_/VMAkbbRv3yY6kZKT6f+FoPG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Ewan Milne <emilne@redhat.com> on Fri, 2015/03/20 11:04:
> On Fri, 2015-03-20 at 15:31 +0100, Christian Hesse wrote:
> > Ewan Milne <emilne@redhat.com> on Fri, 2015/03/20 09:51:
> > > On Fri, 2015-03-20 at 13:57 +0100, Christian Hesse wrote:
> > > > Hello everybody!
> > > >=20
> > > > I reported this issue at LKML [0] but received no answer. Hopefully
> > > > linux-scsi is a better place...
> > > >=20
> > > > Beginning with linux 3.19 I see an iSCSI regressen. This works
> > > > perfectly with linux 3.18.x (tested with 3.18.6) and before. Effect=
ed
> > > > kernels I tested are 3.19.0, 3.19.2 and 4.0rc4.r199.gb314aca.
> > > >=20
> > > > The logs tell the story:
> > > >=20
> > > > Feb 19 11:26:49 thebe kernel: scsi host6: iSCSI Initiator over TCP/=
IP
> > > > Feb 19 11:26:49 thebe kernel: scsi 6:0:0:0: Direct-Access     QNAP
> > > > iSCSI Storage    4.0  PQ: 0 ANSI: 5 Feb 19 11:26:49 thebe kernel: sd
> > > > 6:0:0:0: [sdb] 1073741824 512-byte logical blocks: (549 GB/512 GiB)
> > > > Feb 19 11:26:49 thebe kernel: sd 6:0:0:0: [sdb] Write Protect is off
> > > > Feb 19 11:26:49 thebe kernel: sd 6:0:0:0: [sdb] Mode Sense: 2f 00 00
> > > > 00 Feb 19 11:26:49 thebe kernel: sd 6:0:0:0: [sdb] Write cache:
> > > > disabled, read cache: enabled, doesn't support DPO or FUA Feb 19
> > > > 11:26:49 thebe kernel: sdb: unknown partition table Feb 19 11:26:49
> > > > thebe kernel: sd 6:0:0:0: [sdb] Attached SCSI disk Feb 19 11:26:49
> > > > thebe iscsid[10804]: Connection1:0 to [target:
> > > > iqn.2004-04.com.qnap:ts-859:iscsi.xxxxxxx.c40a18, portal:
> > > > xx.xx.xx.xx,3260] through [iface: default] is operational now Feb 19
> > > > 11:26:57 thebe kernel:  sdb: unknown partition table Feb 19 11:28:20
> > > > thebe kernel: EXT4-fs (dm-8): mounting with "discard" option, but t=
he
> > > > device does not support discard Feb 19 11:28:20 thebe kernel: EXT4-=
fs
> > > > (dm-8): mounted filesystem with ordered data mode. Opts: (null) Feb=
 19
> > > > 11:28:24 thebe kernel: sd 6:0:0:0: [sdb] UNKNOWN Result: hostbyte=
=3D0x00
> > > > driverbyte=3D0x08 Feb 19 11:28:24 thebe kernel: sd 6:0:0:0: [sdb] S=
ense
> > > > Key : 0x5 [current] Feb 19 11:28:24 thebe kernel: sd 6:0:0:0: [sdb]
> > > > ASC=3D0x24 ASCQ=3D0x0 Feb 19 11:28:24 thebe kernel: sd 6:0:0:0: [sd=
b] CDB:
> > > > Feb 19 11:28:24 thebe kernel: cdb[0]=3D0x2a: 2a 00 34 5b 07 ff 00 2=
f 88
> > > > 00 Feb 19 11:28:24 thebe kernel: blk_update_request: critical target
> > > > error, dev sdb, sector 878381055 Feb 19 11:28:24 thebe kernel:
> > > > EXT4-fs warning (device dm-8): ext4_end_bio:317: I/O error -121
> > > > writing to inode 33196503 (offset 8388608 size 7278592 starting blo=
ck
> > > > 108749056) Feb 19 11:28:24 thebe kernel: Buffer I/O error on device
> > > > dm-8, logical block 108749056 Feb 19 11:28:24 thebe kernel: Buffer
> > > > I/O error on device dm-8, logical block 108749057 Feb 19 11:28:24
> > > > thebe kernel: Buffer I/O error on device dm-8, logical block
> > > > 108749058 Feb 19 11:28:24 thebe kernel: Buffer I/O error on device
> > > > dm-8, logical block 108749059 Feb 19 11:28:24 thebe kernel: Buffer
> > > > I/O error on device dm-8, logical block 108749060 Feb 19 11:28:24
> > > > thebe kernel: Buffer I/O error on device dm-8, logical block
> > > > 108749061 Feb 19 11:28:24 thebe kernel: Buffer I/O error on device
> > > > dm-8, logical block 108749062 Feb 19 11:28:24 thebe kernel: Buffer
> > > > I/O error on device dm-8, logical block 108749063 Feb 19 11:28:24
> > > > thebe kernel: Buffer I/O error on device dm-8, logical block
> > > > 108749064 Feb 19 11:28:24 thebe kernel: Buffer I/O error on device
> > > > dm-8, logical block 108749065 Feb 19 11:28:24 thebe kernel: EXT4-fs
> > > > warning (device dm-8): ext4_end_bio:317: I/O error -121 writing to
> > > > inode 33196503 (offset 8388608 size 7278592 starting block 10874931=
2)
> > > > Feb 19 11:28:24 thebe kernel: EXT4-fs warning (device dm-8):
> > > > ext4_end_bio:317: I/O error -121 writing to inode 33196503 (offset
> > > > 8388608 size 7278592 starting block 108749568) Feb 19 11:28:24 thebe
> > > > kernel: EXT4-fs warning (device dm-8): ext4_end_bio:317: I/O error
> > > > -121 writing to inode 33196503 (offset 8388608 size 7278592 starting
> > > > block 108749824) Feb 19 11:28:24 thebe kernel: EXT4-fs warning
> > > > (device dm-8): ext4_end_bio:317: I/O error -121 writing to inode
> > > > 33196503 (offset 8388608 size 7278592 starting block 108750080) Feb
> > > > 19 11:28:24 thebe kernel: EXT4-fs warning (device dm-8):
> > > > ext4_end_bio:317: I/O error -121 writing to inode 33196503 (offset
> > > > 8388608 size 7278592 starting block 108750336) Feb 19 11:29:10 thebe
> > > > kernel: sd 6:0:0:0: [sdb] UNKNOWN Result: hostbyte=3D0x00
> > > > driverbyte=3D0x08 Feb 19 11:29:10 thebe kernel: sd 6:0:0:0: [sdb] S=
ense
> > > > Key : 0x5 [current] Feb 19 11:29:10 thebe kernel: sd 6:0:0:0: [sdb]
> > > > ASC=3D0x24 ASCQ=3D0x0 Feb 19 11:29:10 thebe kernel: sd 6:0:0:0: [sd=
b]
> > > > CDB: Feb 19 11:29:10 thebe kernel: cdb[0]=3D0x2a: 2a 00 20 44 89 17=
 00
> > > > 20 50 00 Feb 19 11:29:10 thebe kernel: blk_update_request: critical
> > > > target error, dev sdb, sector 541362455 Feb 19 11:29:10 thebe kerne=
l:
> > > > Buffer I/O error on dev dm-8, logical block 66621731, lost sync page
> > > > write Feb 19 11:29:10 thebe kernel: Aborting journal on device
> > > > dm-8-8. Feb 19 11:29:10 thebe kernel: EXT4-fs error (device dm-8):
> > > > ext4_journal_check_start:56: Detected aborted journal Feb 19 11:29:=
10
> > > > thebe kernel: EXT4-fs (dm-8): Remounting filesystem read-only Feb 19
> > > > 11:29:20 thebe kernel: EXT4-fs error (device dm-8):
> > > > ext4_put_super:780: Couldn't clean up the journal
> > > >=20
> > > > [0] https://lkml.org/lkml/2015/2/19/91
> > >=20
> > > Sense key 0x5 ASC/ASCQ 0x24 0x00 is ILLEGAL REQUEST, INVALID FIELD IN
> > > CDB.  The CDB was 2A 00 34 5B 07 FF 00 2F 88 00, which is a WRITE_10
> > > to LBA 878381055 with a length of 12168 blocks (a little less than 6M=
B).
> > > It looks like this is within the reported capacity of the device, and
> > > there are no other bits set in the CDB.
> > >=20
> > > Looks like you could get this error if RWWP (reject without write
> > > protection) is set in the control mode page.  I don't see any messages
> > > about the protection type, though.  What does sysfs report?
> >=20
> > Is that what you are interested in?
> >=20
> > # cat protection_mode protection_type=20
> > none
> > 0
> >=20
> > In case it matters: The iSCSI device is LUKS encrypted, that is why dev=
ice
> > mapper shows up.
> >=20
> > I removed the discard option from filesystem's default mount option, but
> > that brings no difference except the message is not printed.
>=20
> It is most likely the device that is returning the error, there is a
> place in the iSCSI Initiator that generates an ILLEGAL REQUEST sense,
> but it is not the same ASC/ASCQ.
>=20
> There was this change:
>=20
> commit bcdb247c6b6a1f3e72b9b787b73f47dd509d17ec
> Author: Martin K. Petersen <martin.petersen@oracle.com>
> Date:   Tue Jun 3 18:45:51 2014 -0400
>=20
>     sd: Limit transfer length
>    =20
>     Until now the per-command transfer length has exclusively been gated =
by
>     the max_sectors parameter in the scsi_host template. Given that the s=
ize
>     of this parameter has been bumped to an unsigned int we have to be
>     careful not to exceed the target device's capabilities.
>    =20
>     If the if the device specifies a Maximum Transfer Length in the Block
>     Limits VPD we'll use that value. Otherwise we'll use 0xffffffff for
>     devices that have use_16_for_rw set and 0xffff for the rest. We then
>     combine the chosen disk limit with max_sectors in the host template. =
The
>     smaller of the two will be used to set the max_hw_sectors queue limit.
>    =20
>     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>     Reviewed-by: Ewan D. Milne <emilne@redhat.com>
>     Signed-off-by: Christoph Hellwig <hch@lst.de>
>=20
> What is the value of max_sectors_kb and queue_max_sectors_kb in sysfs
> for the device?  Is it different than what is reported on 3.18?

I reverted these two commits:

commit 3a9794d32984b67a6d8992226918618f0e51e5d5
Author: Brian King <brking@linux.vnet.ibm.com>
Date:   Thu Jan 29 15:54:40 2015 -0600

    sd: Fix max transfer length for 4k disks

commit bcdb247c6b6a1f3e72b9b787b73f47dd509d17ec
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:   Tue Jun 3 18:45:51 2014 -0400

    sd: Limit transfer length
=20
iSCSI device still fails, max_sectors_kb is still set to 32767. Looks like
there is another change that introduced the regression.
--=20
main(a){char*c=3D/*    Schoene Gruesse                         */"B?IJj;MEH"
"CX:;",b;for(a/*    Chris           get my mail address:    */=3D0;b=3Dc[a+=
+];)
putchar(b-1/(/*               gcc -o sig sig.c && ./sig    */b/42*2-3)*42);}

--Sig_/VMAkbbRv3yY6kZKT6f+FoPG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVD9R0AAoJEIlFIdfMgPR2dJ8IAMbkzQYFdGrvSzF5htPFDcBz
ttdUAeJTNs+EKDz/5C1k6ELNx4chjoEhfRQurzALqdKIZjUSbPOIAtZ8QA479OBg
n8/N1HlCQ6dspcCP5Hsk7rrqvW+1pP7221ECwEj/B1bb2ImNqHtbm+jeOtpK+1D9
qL2wvotK3iOPUj7jUtX0OnvQotzFqx+V6h5uzJ3lpfSriXHXHNYgMV1t7NPnCE67
enj2FnKOZPGKX9dVVx0joML8cHW9OEjiBbnseIUcnTFxVW3d66YHKbuErg/5iFA6
CzvvLQqECY0sNX5lonBLATcexUfTQGBV9CjbHavDYkjzEWxVqFEGkT2+ryaaWK0=
=4XdQ
-----END PGP SIGNATURE-----

--Sig_/VMAkbbRv3yY6kZKT6f+FoPG--
