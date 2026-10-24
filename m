Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.37.111.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792854551;
	b=Mp2oDALAp55DxIrjT405A8HE0DHVHW8qDX2+PN5AeuzJjYuVp8hSnzDUC22Ae3xP2RQF
	 cZMD+JsRg+QBpgFhFkdY1uhm0u/M51YRSNPO1ZCDElHmdBgTUMHQrx0SrBby4lO2CM8sO
	 6XUdsvYrzNVZfKEdk1MamS4FgIaIobh0sP5sfyuwfLZmYcrwgNo5sVVg6Z+YhD4GmNfu4
	 1SQfyhFFmQSSlTPMju03dqNG0DbuJm9xMMCINi9kFOhojzKdoF6sTQ0+BX92IaTlRXMp7
	 EjpT85zyOpxvF5EhFN5mmpK08GdxE2odmcOHPdh/SCoJovcNA2uoIX4KUMBRjWYgGqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792854551;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:
	 Date:Autocrypt:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=9TFuM2PkMNm4FJO+TMAn8pRJc7jwhD6Nz+dnPZDZv6w=;
	b=go5NvCV1aRogZFZOvRG0puJ5t0Qctpz15DGnZJmF9WNUiOXjqWyl5S+qPCu2e6O8UOYk
	 dpFIHG4nHVpL0K+90zK00yzVRgxnjC2oAPTorFSv2FLyssuNpa9y+UU5snb4OLGdY5OsG
	 W4YVHJMABF+St/bne786tluajVPbW669iDmMdRWE1X/iWP5SrDuNCaoJX2PMzYG+QxCg2
	 l1ev5+bFLXj0Rp9HK4YoHo6Mhs6kBwpNdpzELV6zq7e5zuOqfgb4rR3KZGIl7H6w3JCRQ
	 gryQJrDSp/dw0eiFlCekZK/ANCRPENzzt4tEUEAU8eQyZ1BZFVl4rz3nitMhzxJfNMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=HansenPartnership.com;
	spf=pass smtp.mailfrom=HansenPartnership.com;
	dkim=pass header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=dy0ncMuC;
	arc=none smtp.remote-ip=198.37.111.173
Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68450606A31A;
	Sat, 24 Oct 2026 15:09:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68450606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=dy0ncMuC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1792854549;
	bh=qJbAEHYluzxThtSOLVQzY43XRTSJVlGKjPe84Ibg6TM=;
	h=Message-ID:Subject:From:To:Date:From;
	b=dy0ncMuC3CsjBsyZunp/5fEgSbMwTauVq+njsjz+3aJJhkt0KY70zV0aeEhTSZktw
	 /wKGbcASldtSVOMi7+qkZQMfBl7sj43RAmOyki2YnLSBV9qMjZ1gxukJ48kc7b6OZW
	 lUhF/RjPhXzuJIm6Xj+MYKMrbiXFiX2DBhxC6QMg=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 175F11C0030;
	Sat, 24 Oct 2026 11:09:09 -0400 (EDT)
Message-ID: <80d0631c1c5dbb4c62dd26ad813f595e41d855a0.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI updates for the 7.3+ merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sat, 24 Oct 2026 11:09:08 -0400
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 keydata=mQENBE58FlABCADPM714lRLxGmba4JFjkocqpj1/6/Cx+IXezcS22azZetzCXDpm2MfNE
 lecY3qkFjfnoffQiw5rrOO0/oRSATOh8+2fmJ6el7naRbDuh+i8lVESfdlkoqX57H5R8h/UTIp6gn
 1mpNlxjQv6QSZbl551zQ1nmkSVRbA5TbEp4br5GZeJ58esmYDCBwxuFTsSsdzbOBNthLcudWpJZHU
 RfMc0ew24By1nldL9F37AktNcCipKpC2U0NtGlJjYPNSVXrCd1izxKmO7te7BLP+7B4DNj1VRnaf8
 X9+VIApCi/l4Kdx+ZR3aLTqSuNsIMmXUJ3T8JRl+ag7kby/KBp+0OpotABEBAAG0N0phbWVzIEJvd
 HRvbWxleSA8SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT6JAVgEEwEIAEICGw
 MGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAhkBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAml2ZBI
 FCS3GUMIACgkQgUrkfCFIVNZKjQf/deRzlXZClKxTC/Ee2yEPqqS7mm/INUA49KdQQ5oIhSxkUBy0
 9J4qjMIo5F8ZFkFTqikBqeL35LKu7O7rn8WETfX8Bxvos3HUsl3jHo34DES4MUFIpoQPgtiLRGwLb
 K0cVCAArR2u2qj4ABmTRrs1I1kvdjEw6gatOuXtEe/j5O2fvfzTq9GBr0Q3n2IAsFXi4hLlx6VPE8
 tyWUZ8BWJKtih3JAeUiXFvASL3McV0rV9RnU0VbjEQEhSE7PMYhWpnDC9AyBb0lXJllQRvC3NSkUB
 8KVQgNNxRPss0WE/nBoZ4dFA42jTyzTz8lNylxZoAWV7WJb3QxVg4oCodRVrxxrQhSmFtZXMgQm90
 dG9tbGV5IDxqZWpiQGtlcm5lbC5vcmc+iQFVBBMBCAA/AhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeA
 QIXgBYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJgS5mYBQkbNYS9AAoJEIFK5HwhSFTWBpwIAL5Bk3
 5FB34U6iHmDzzgdCbxLTs43T/YQyJpcGIvopBvnI/fDY8oSG6Df64/O6B+1R+A8TDp6ZG5ysUWnCC
 6GuIaEHemBYkitMPglR6+sGCMQY7O0mlsPvdssvKK1KI9Bno4VU6ogaF2qVzefSqg1Djmf/DcsxWP
 rI/jdJ8FB5AYR2rjIdDFc+zRdAJuavo1/anyY2wgpFh/3R8IOYAEfWV9nGgYkf9+tA4EIn1sxE0I3
 L5oW2N3mbyRrkzuBwO8ztMCwqEPk7moWzhokcZqMXiAIahaZdkashJC+s2X2RZSGCy+g+pvY5NN4B
 BVG5XwLgVBqbHMTcxE0fbmPqz+q6O0LEphbWVzIEJvdHRvbWxleSA8amVqYkBoYW5zZW5wYXJ0bmV
 yc2hpcC5jb20+iQFXBBMBCABBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAmODZ5ACGwMFCRs1hL0F
 CwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQgUrkfCFIVNZu0Af/TzvL2/NdgAcw9uN3x60H8
 jc4QUq14VpxcFEFEMpcj1morkX/G93V+56HBBaXZj+yK8PhxIA/SIz+sU7C/0YvKuvzakP8ZX/7WJ
 e32SOUtjfr/VTaqjIBzNj6OxLvZpmNbBw7s6DwhhNpHOWqJ/1ml+PtDRDV71IB58yVqQjp1xlNKVl
 ZppcJ5908EJzsFnRIVjiQiDSKoppqB2BCibBbrWcln7CiWMyOC/cco6SIn6twH+f7+aivJ3xGcOE2
 a9gBKF5rNi9TBoX9oyPmshv/TDmnohsVrH7AYXlGYfZTk15SWEiROh1QX8/uD9wl/gcIv5EDUpT/F
 L2jzOsA5663bw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

The following changes since commit df2908090cda368b01ff43709f51890076c56157=
:

  Linux 7.3-rc2 (2026-09-06 15:07:20 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-=
misc

for you to fetch changes up to 2f4880c22e838d54eae9ab153b0f8dce60531bf1:

  scsi: ufs: rpmb: Fix power-on UNIT ATTENTION retry (2026-10-05 22:09:17 -=
0400)

----------------------------------------------------------------
Small number of driver updates (mpi3mr, ufs, scsi_debug).  By far the
biggest core change (at 4000+ lines) is the sense code rework to make
our sense handling follow the 16 bit defines in the SCSI standard rather
than our split ASC and ASCQ handling which ends up being confusing and
difficult to grep.  The changes should all be functionally equivalent
and so far the bots and AI seem to agree; the code has been incubating
in -next since 16 September with one reported issue fixed.  The
remaining updates are minor.

----------------------------------------------------------------
Bart Van Assche (3):
      scsi: pm8001: Fix SATA FIS offset in struct hw_event_resp
      scsi: core: Fix scsi_done() documentation
      scsi: core: Micro-optimize the hot path

Bean Huo (2):
      scsi: ufs: core: Record the frequency the controller starts at
      scsi: ufs: core: Report the current clock frequency to devfreq

Bill Wendling (2):
      scsi: bfa: Use snprintf() in bfa_fcs_fabric_nsymb_init()
      scsi: bfa: Use snprintf() in bfa_fcs_fabric_psymb_init()

Chandrakanth Patil (17):
      scsi: mpi3mr: Fix buffer overflow in BSG passthrough request copy
      scsi: mpi3mr: Fix out-of-bounds read when copying BSG MPI requests
      scsi: mpi3mr: Fix I/O block counter leak on admin request post failur=
e
      scsi: mpi3mr: Fix target device reference leak in BSG task management
      scsi: mpi3mr: Fix buffer overflow when caching log data
      scsi: mpi3mr: Fix out-of-bounds reply frame access
      scsi: mpi3mr: Fix out-of-bounds sense buffer access
      scsi: mpi3mr: Fix out-of-bounds bitmap access during device removal
      scsi: mpi3mr: Fix target device reference leak in device removal hand=
shake
      scsi: mpi3mr: Fix out-of-bounds read in SAS topology change events
      scsi: mpi3mr: Fix out-of-bounds read of event data
      scsi: mpi3mr: Fix out-of-bounds phy array access on link change
      scsi: mpi3mr: Fix buffer overflow in the BSG target device map
      scsi: mpi3mr: Fix out-of-bounds read in PCIe topology change events
      scsi: mpi3mr: zero out diagnostic buffer status memory
      scsi: mpi3mr: Fix use-after-free of the firmware event workqueue
      scsi: mpi3mr: Fix NULL pointer dereference on PCI error recovery

Christoph Hellwig (1):
      scsi: scsi_debug: Add support to corrupt data and/or reftag

Damien Le Moal (41):
      scsi: core: Define all additional sense codes and their qualifiers
      scsi: core: constants: Use defined sense codes
      scsi: core: constants: Rename internal struct field names
      scsi: core: Rename sense field of struct scsi_failure
      scsi: core: Prepare for using combined sense codes
      scsi: core: Use struct scsi_sense_hdr to log sense keys and codes
      scsi: core: Use combined sense codes
      scsi: sd: Use combined sense codes
      scsi: sr: Use combined sense codes
      scsi: ses: Use combined sense codes
      scsi: ch: Use combined sense codes
      scsi: st: Use combined sense codes
      scsi: device_handlers: hp_sw: Use combined sense codes
      scsi: device_handlers: rdac: Use combined sense codes
      scsi: device_handlers: emc: Use combined sense codes
      scsi: device_handlers: alua: Use combined sense codes
      scsi: mpt3sas: Use combined sense codes
      scsi: mpi3mr: Use combined sense codes
      scsi: 3w-xxxx: Use combined sense codes
      scsi: leapraid: Use combined sense codes
      scsi: megaraid: Use combined sense codes
      scsi: myrb: myrs: Use combined sense codes
      scsi: smartpqi: Use combined sense codes
      scsi: qla2xxx: Use combined sense codes
      scsi: ps3rom: Use combined sense codes
      scsi: lpfc: Use combined sense codes
      scsi: stex: Use combined sense codes
      scsi: mvumi: Use combined sense codes
      scsi: libiscsi: Use combined sense codes
      scsi: ibmvscsi_tgt: Use combined sense codes
      scsi: scsi_debug: Use combined sense codes
      scsi: hpsa: Use combined sense codes
      scsi: storvsc: Use combined sense codes
      scsi: target: Use combined sense codes
      scsi: usb: storage: Use combined sense codes
      scsi: cdrom: Use combined sense codes
      scsi: ata: libata: Use combined sense codes
      scsi: s390: Use combined sense codes
      scsi: core: Clean up scsi_proto.h
      scsi: core: Remove scsi_build_sense() and scsi_build_sense_buffer()
      scsi: core: Fix additional sense code definition

Fan Wu (1):
      scsi: dc395x: sync the waiting_timer before freeing the host

Geert Uytterhoeven (1):
      scsi: zorro7xx: Use individual zorro_driver_data structures

John Garry (2):
      scsi: core: Drop Scsi_Host.default_lock
      scsi: scsi_debug: Default to a higher throughput config

Jorge Ramirez-Ortiz (2):
      scsi: ufs: rpmb: Retry power-on UNIT ATTENTION on the RPMB WLUN
      scsi: ufs: rpmb: Use a fixed-length RPMB dev_id

Kees Cook (1):
      scsi: hpsa: Make buff allocation type unsigned

Laurence Oberman (4):
      scsi: st: Restore changed drive settings after reset also for MTLOAD =
and MTRETEN
      scsi: st: Record the tape position after a successful MTLOAD
      scsi: st: Restore the drive buffering mode after reset
      scsi: st: Relock the door after a reset

Martin K. Petersen (Oracle) (10):
      Merge patch series "scsi: replace __get_free_pages() with kmalloc()"
      Merge patch series "ufs: rpmb: make RPMB usable with OP-TEE key deriv=
ation"
      Merge patch series "scsi: mpi3mr: Fix out-of-bounds accesses and refe=
rence leaks"
      Merge patch series "devfreq: check the get_cur_freq() return value an=
d use it in ufshcd"
      Merge patch series "Use defined 16-bits ASC/ASCQ combinations"
      Merge patch series "mpi3mr: Few Enhancements and minor fixes"
      Merge tag 'v7.3-rc2' into 7.4/scsi-staging
      scsi: mpi3mr: Fix merge error
      Merge patch series "scsi: scsi_debug: fix zoned write validation"
      Merge patch series "scsi: st: Restore drive settings and state after =
reset and MTLOAD"

Mike Rapoport (Microsoft) (4):
      scsi: target: file: Use kmalloc() to allocate temporary protection bu=
ffer
      scsi: proc: Use kmalloc() in proc writers
      scsi: ipr: Use kmalloc() to allocate IPR dump buffer memory
      scsi: sym53c8xx_2: Replace __get_free_pages() with kmalloc()

Niklas Cassel (13):
      scsi: scsi_debug: Refuse a zoned device with a non-zero lowest aligne=
d LBA
      scsi: scsi_debug: Make atomic writes and ZBC emulation mutually exclu=
sive
      scsi: scsi_debug: Refuse a negative physblk_exp
      scsi: scsi_debug: Take the zone metadata lock before the data lock
      scsi: scsi_debug: Evaluate scsi_debug_lbp() only once
      scsi: scsi_debug: Avoid 32-bit overflow in WRITE SCATTERED offsets
      scsi: scsi_debug: Report the residual of a write
      scsi: scsi_debug: Enforce physical block alignment of zoned writes
      scsi: scsi_debug: Do not write a partial physical block to a zoned de=
vice
      scsi: scsi_debug: Advance the write pointer over the data written
      scsi: scsi_debug: Refuse a short WRITE ATOMIC (16) before writing it
      scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
      scsi: scsi_debug: Validate the access parameters of WRITE ATOMIC (16)

Nitin Rawat (1):
      scsi: ufs: ufs-qcom: Enable only lane clocks in lane clock APIs

Peng Fan (1):
      scsi: target: core: Use assign_bit() where applicable

Peter Wang (2):
      scsi: ufs: core: Always notify POST_CHANGE even on gear switch failur=
e
      scsi: ufs: core: Serialize AHIT register access between sysfs and hos=
t driver

Ranjan Kumar (10):
      scsi: mpi3mr: Skip device shutdown during unload per controller confi=
guration
      scsi: mpi3mr: Update MPI Headers to revision 41
      scsi: mpi3mr: Add early timestamp synchronization after driver load
      scsi: mpi3mr: Fix NVMe page size caching for non-operational devices
      scsi: mpi3mr: Fix performance regression caused by extended IRQ poll =
sleep
      scsi: mpi3mr: Fix memory leak on operational queue creation failure
      scsi: mpi3mr: Fix firmware event reference leak during cleanup
      scsi: mpi3mr: Fix SAS port allocation and registration error handling
      scsi: mpi3mr: Fix SAS PHY cleanup in host addition error paths
      scsi: mpi3mr: Driver version update to 8.18.0.8.50

Shawn Guo (1):
      scsi: ufs: qcom: Enable MCQ support for sa8255p

Stanley Jhu (4):
      scsi: ufs: core: Fast-abort unsupported Query IDNs
      scsi: ufs: core: Dynamically disable timestamp on unsupported devices
      scsi: MAINTAINERS: Remove Avri Altman as UFS reviewer
      scsi: ufs: rpmb: Fix power-on UNIT ATTENTION retry

 Documentation/scsi/scsi_mid_low_api.rst      |   32 +-
 MAINTAINERS                                  |    1 -
 drivers/ata/libata-eh.c                      |   17 +-
 drivers/ata/libata-sata.c                    |   20 +-
 drivers/ata/libata-scsi.c                    |  344 ++--
 drivers/ata/libata.h                         |    5 +-
 drivers/cdrom/cdrom.c                        |   10 +-
 drivers/message/fusion/mptfc.c               |    8 +-
 drivers/s390/scsi/zfcp_erp.c                 |   30 +-
 drivers/s390/scsi/zfcp_ext.h                 |    2 +-
 drivers/s390/scsi/zfcp_fsf.c                 |    9 +-
 drivers/s390/scsi/zfcp_scsi.c                |    6 +-
 drivers/s390/scsi/zfcp_sysfs.c               |    4 +-
 drivers/scsi/3w-9xxx.c                       |   20 +-
 drivers/scsi/3w-sas.c                        |   28 +-
 drivers/scsi/3w-xxxx.c                       |   27 +-
 drivers/scsi/53c700.c                        |   16 +-
 drivers/scsi/BusLogic.c                      |   20 +-
 drivers/scsi/a100u2w.c                       |    4 +-
 drivers/scsi/a2091.c                         |    4 +-
 drivers/scsi/a3000.c                         |    4 +-
 drivers/scsi/aacraid/commsup.c               |    8 +-
 drivers/scsi/advansys.c                      |    8 +-
 drivers/scsi/aha1542.c                       |   20 +-
 drivers/scsi/aha1740.c                       |   12 +-
 drivers/scsi/arm/eesox.c                     |    8 +-
 drivers/scsi/arm/fas216.c                    |   20 +-
 drivers/scsi/atp870u.c                       |   12 +-
 drivers/scsi/bfa/bfa_fcs.c                   |   88 +-
 drivers/scsi/bfa/bfad_bsg.c                  |    4 +-
 drivers/scsi/ch.c                            |   55 +-
 drivers/scsi/constants.c                     |   61 +-
 drivers/scsi/csiostor/csio_attr.c            |    4 +-
 drivers/scsi/csiostor/csio_scsi.c            |    4 +-
 drivers/scsi/dc395x.c                        |   18 +-
 drivers/scsi/device_handler/scsi_dh_alua.c   |   55 +-
 drivers/scsi/device_handler/scsi_dh_emc.c    |   28 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c  |   29 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c   |   55 +-
 drivers/scsi/esp_scsi.c                      |   32 +-
 drivers/scsi/fcoe/fcoe.c                     |    4 +-
 drivers/scsi/fdomain.c                       |   16 +-
 drivers/scsi/gvp11.c                         |    4 +-
 drivers/scsi/hosts.c                         |   17 +-
 drivers/scsi/hpsa.c                          |   71 +-
 drivers/scsi/hpsa_cmd.h                      |   23 -
 drivers/scsi/hptiop.c                        |    8 +-
 drivers/scsi/ibmvscsi/ibmvfc-core.c          |  262 +--
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c          |    8 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c             |   86 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     |    5 +-
 drivers/scsi/imm.c                           |    4 +-
 drivers/scsi/initio.c                        |    8 +-
 drivers/scsi/ipr.c                           |  324 ++--
 drivers/scsi/ips.c                           |   26 +-
 drivers/scsi/leapraid/leapraid_func.h        |    7 -
 drivers/scsi/leapraid/leapraid_os.c          |   15 +-
 drivers/scsi/libfc/fc_fcp.c                  |    8 +-
 drivers/scsi/libiscsi.c                      |    3 +-
 drivers/scsi/libsas/sas_scsi_host.c          |   10 +-
 drivers/scsi/lpfc/lpfc_els.c                 |   30 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c             |   44 +-
 drivers/scsi/lpfc/lpfc_init.c                |   16 +-
 drivers/scsi/lpfc/lpfc_scsi.c                |   26 +-
 drivers/scsi/lpfc/lpfc_sli.c                 |    4 +-
 drivers/scsi/mac53c94.c                      |    8 +-
 drivers/scsi/megaraid.c                      |    8 +-
 drivers/scsi/megaraid/mega_common.h          |    2 -
 drivers/scsi/megaraid/megaraid_mbox.c        |   12 +-
 drivers/scsi/megaraid/megaraid_sas_base.c    |   18 +-
 drivers/scsi/mesh.c                          |   24 +-
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h         |   77 +-
 drivers/scsi/mpi3mr/mpi/mpi30_image.h        |    7 +-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h          |   15 +-
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h    |    2 +-
 drivers/scsi/mpi3mr/mpi3mr.h                 |   13 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c             |   87 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c              |  223 ++-
 drivers/scsi/mpi3mr/mpi3mr_os.c              |  320 +++-
 drivers/scsi/mpi3mr/mpi3mr_transport.c       |  104 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c         |   69 +-
 drivers/scsi/mvumi.c                         |   28 +-
 drivers/scsi/myrb.c                          |   67 +-
 drivers/scsi/myrs.c                          |   23 +-
 drivers/scsi/nsp32.c                         |    8 +-
 drivers/scsi/pcmcia/sym53c500_cs.c           |    8 +-
 drivers/scsi/pm8001/pm8001_defs.h            |   98 +
 drivers/scsi/pm8001/pm8001_hwi.c             |    2 +-
 drivers/scsi/pm8001/pm8001_hwi.h             |    4 +-
 drivers/scsi/pm8001/pm80xx_hwi.c             |    2 +-
 drivers/scsi/pm8001/pm80xx_hwi.h             |  100 +-
 drivers/scsi/pmcraid.c                       |   84 +-
 drivers/scsi/ps3rom.c                        |    5 +-
 drivers/scsi/qla1280.c                       |   44 +-
 drivers/scsi/qla2xxx/qla_attr.c              |    4 +-
 drivers/scsi/qla2xxx/qla_init.c              |    4 +-
 drivers/scsi/qla2xxx/qla_isr.c               |    9 +-
 drivers/scsi/qla2xxx/qla_target.c            |   99 +-
 drivers/scsi/qla2xxx/qla_target.h            |    3 -
 drivers/scsi/qlogicfas408.c                  |    8 +-
 drivers/scsi/qlogicpti.c                     |   20 +-
 drivers/scsi/scsi.c                          |   15 +-
 drivers/scsi/scsi_common.c                   |   24 +-
 drivers/scsi/scsi_debug.c                    |  647 +++++--
 drivers/scsi/scsi_debugfs.c                  |    2 +-
 drivers/scsi/scsi_devinfo.c                  |    5 +-
 drivers/scsi/scsi_error.c                    |  165 +-
 drivers/scsi/scsi_ioctl.c                    |    3 +-
 drivers/scsi/scsi_lib.c                      |  182 +-
 drivers/scsi/scsi_lib_test.c                 |   95 +-
 drivers/scsi/scsi_logging.c                  |   22 +-
 drivers/scsi/scsi_proc.c                     |    9 +-
 drivers/scsi/scsi_scan.c                     |   38 +-
 drivers/scsi/scsi_sysfs.c                    |   28 +-
 drivers/scsi/scsi_transport_fc.c             |  136 +-
 drivers/scsi/scsi_transport_spi.c            |   12 +-
 drivers/scsi/sd.c                            |  126 +-
 drivers/scsi/sd_zbc.c                        |    2 +-
 drivers/scsi/sense_codes.h                   | 2496 +++++++++++++++++-----=
----
 drivers/scsi/ses.c                           |   23 +-
 drivers/scsi/sgiwd93.c                       |    4 +-
 drivers/scsi/smartpqi/smartpqi_init.c        |   31 +-
 drivers/scsi/snic/snic_disc.c                |   16 +-
 drivers/scsi/sr.c                            |    3 +-
 drivers/scsi/sr_ioctl.c                      |   29 +-
 drivers/scsi/st.c                            |  132 +-
 drivers/scsi/st.h                            |    2 +
 drivers/scsi/stex.c                          |   51 +-
 drivers/scsi/storvsc_drv.c                   |   15 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c          |   56 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.h          |    4 +-
 drivers/scsi/wd33c93.c                       |    4 +-
 drivers/scsi/wd719x.c                        |   24 +-
 drivers/scsi/xen-scsifront.c                 |   40 +-
 drivers/scsi/zorro7xx.c                      |   31 +-
 drivers/target/target_core_file.c            |    4 +-
 drivers/target/target_core_pscsi.c           |   16 +-
 drivers/target/target_core_spc.c             |   11 +-
 drivers/target/target_core_transport.c       |   11 +-
 drivers/target/target_core_ua.c              |   28 +-
 drivers/target/target_core_ua.h              |    7 +-
 drivers/target/target_core_user.c            |    5 +-
 drivers/ufs/Kconfig                          |    1 +
 drivers/ufs/core/ufs-debugfs.c               |    4 +-
 drivers/ufs/core/ufs-rpmb.c                  |   30 +-
 drivers/ufs/core/ufs-sysfs.c                 |   12 +-
 drivers/ufs/core/ufshcd.c                    |  250 ++-
 drivers/ufs/host/ufs-exynos.c                |    4 +-
 drivers/ufs/host/ufs-mediatek.c              |   20 +-
 drivers/ufs/host/ufs-qcom.c                  |   52 +-
 drivers/ufs/host/ufs-qcom.h                  |    5 +-
 drivers/ufs/host/ufs-sprd.c                  |    4 +-
 drivers/ufs/host/ufshcd-pci.c                |    3 +-
 drivers/usb/gadget/function/f_mass_storage.c |   34 +-
 drivers/usb/gadget/function/storage_common.h |   71 +-
 drivers/usb/storage/debug.c                  |   11 +-
 drivers/usb/storage/debug.h                  |    4 +-
 drivers/usb/storage/transport.c              |    7 +-
 drivers/usb/storage/uas.c                    |   12 +-
 drivers/usb/storage/usb.h                    |    4 +-
 include/scsi/scsi_cmnd.h                     |    3 +-
 include/scsi/scsi_common.h                   |   16 +-
 include/scsi/scsi_dbg.h                      |    6 +-
 include/scsi/scsi_device.h                   |   26 +-
 include/scsi/scsi_host.h                     |    9 +-
 include/scsi/scsi_proto.h                    |   71 +-
 include/scsi/scsi_sense.h                    |  950 ++++++++++
 include/trace/events/scsi.h                  |    4 +-
 include/ufs/ufs.h                            |    1 +
 include/ufs/ufshcd.h                         |    8 +
 170 files changed, 6319 insertions(+), 3627 deletions(-)
 create mode 100644 include/scsi/scsi_sense.h
