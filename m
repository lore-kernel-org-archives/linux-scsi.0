Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.37.111.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793372071;
	b=BiZdOvWfq9kK7+ZbKUmHnSOl8xw5MRMNCO9J4FlmdFy+NAmlNT8tKw4xbLrVS72gINpN
	 SBPLXOzc8qcMDCk0mK/pzKeFP6PR0x9Wg9ArpPQtEIduHkEIfNWLDubNcP+h/OQgQmp9w
	 MrnHpMqlO6sQ94Xr0q2tORC2gez6wD35WQRYKlkDGWfR0XE5JMff9pO/bPnGsqDmDdsI+
	 /2ol5WAjM1HfnDN5S1YoU+69MwnK5yX/+4S5XQ5lSPKyvIPjaeIZ4EIBuIh4JNXzbcapw
	 w0gq8lYaS04j1yaxV+4W617JIp2/ciY4yvNijfx22qZXLGaFd4r8e9us0CV1BNX7WRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793372071;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:
	 Date:Autocrypt:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=JZ5ycCLnifZITjjo8viwpzg/zRWcqGXvIVGpNgGYt+w=;
	b=GkjqCEnujNKkq/yEWx17HO5q/3yWJGzC4xIUpNlNtaEnRlh9YP90327cId5KTzJkgTT8
	 niBXmFPlTyxf9gfRA0s7nLgcUh2kdFI4Rck+V5lxpbNvTmzjWb0KA11BA7EwcLXytnSvx
	 4VqJ70dW/ms0oTvKrUhEZTjlwCowzTTJ4DoSUAnQck+jteLxhKbscUWh0pBb/jhJqZgpN
	 Jj/eHrmdLUlLjYRAxUfOCpJYBNgoC/32pyqzHD5eMA8GjA6/oxFMLhLzMnahH7+tTYIi7
	 3OZGaDSg49o9QjihPMHwc8WAZShsiMeT3Cz0/8DQ8QCezTRq4hNe1ZvAYqgNhIZXUAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=HansenPartnership.com;
	spf=pass smtp.mailfrom=HansenPartnership.com;
	arc=none smtp.remote-ip=198.37.111.173
Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752BE606A31A;
	Fri, 30 Oct 2026 14:54:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 752BE606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1793372069;
	bh=++YuiQ4jSz9j9YicCNnOSMvqFCsEyXy9fLNJ05YnaUQ=;
	h=Message-ID:Subject:From:To:Date:From;
	b=Ylj2Zu2iveQjo1ZusR00cBOU8wPmjpTwLwMtDO9FQ5nDtLjd9tqpDtx+K3oOdk7ed
	 yfxIrL8AsQ9J7pk5FyLI4l9mCINIEWQ8nizu3h51wqMOsmCDZS9bx90vqkzlYSGx7w
	 TCe2DJx/L1fCfIlYeRKjlc54lcZ+fns2wx6xgm88=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 131621C0241;
	Fri, 30 Oct 2026 10:54:29 -0400 (EDT)
Message-ID: <e7a21a9f0a604f3d3303e4f18c3dbc2e0b8ed263.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI final updates for the 7.3+ merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Fri, 30 Oct 2026 10:54:28 -0400
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

The following changes since commit ec6b083915e8146e147314a5f4f1285d07b57bfc=
:

  scsi: bsg: Pass reply_len to bsg_setup_queue() to fit UFS ARPMB replies (=
2026-10-14 22:14:52 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-=
misc

for you to fetch changes up to 3650bb41391b51d9dcf87b0480ecafeb1526252f:

  Merge patch series "scsi: ufs: core: Factor hba->outstanding_reqs helper =
and fix double completions" (2026-10-23 23:17:12 -0400)

----------------------------------------------------------------
A couple of late arriving driver updates (lpfc, ufs) with the main
addition being the lock context analysis update where clang static
analysis coupled with annotations are used to verify driver guarantees
about locks and warn on compile if they're inconsistent; this is mostly
annotations with only a few code changes (except in scsi_debug which
needed a fairly big rework to validate with locking context analysis).

Unfortunately the diffstat of git-request-pull fails on this tree (two
distinct merge bases) so I used my original tooling to generate the
correct one.
----------------------------------------------------------------
Alexander Koskovich (1):
      scsi: ufs: qcom: Power down UFS during system suspend on Milos

Andy Shevchenko (1):
      scsi: ufs: ufs-qcom: Don't define variable in the middle of the code

Bart Van Assche (64):
      scsi: scsi_debug: Fix a locking bug in resp_write_same()
      scsi: scsi_debug: Split resp_write_same()
      scsi: scsi_debug: Split corrupt_lbas()
      scsi: scsi_debug: Split resp_read_dt0()
      scsi: scsi_debug: Split resp_write_dt0()
      scsi: scsi_debug: Split resp_atomic_write()
      scsi: scsi_debug: Improve lock context annotations
      scsi: core: Enable lock context analysis for the scsi_debug driver
      scsi: PCI: Convert to_pci_dev() into an inline function
      scsi: sg: Prepare for enabling lock context analysis
      scsi: st: Prepare for enabling lock context analysis
      scsi: NCR5380: Prepare for enabling lock context analysis
      scsi: aacraid: Enable lock context analysis
      scsi: aha152x: Prepare for enabling lock context analysis
      scsi: aic7xxx: Enable lock context analysis
      scsi: aic94xx: Enable lock context analysis
      scsi: arcmsr: Enable lock context analysis
      scsi: libiscsi: Pass the session pointer directly to several function=
s
      scsi: libiscsi: Prepare for enabling lock context analysis
      scsi: be2iscsi: Enable lock context analysis
      scsi: cxgbi: Enable lock context analysis
      scsi: bfa: Enable lock context analysis
      scsi: bnx2fc: Pass tgt directly to several functions
      scsi: bnx2fc: Enable lock context analysis
      scsi: bnx2i: Enable lock context analysis
      scsi: csiostor: Pass the hw pointer directly to several functions
      scsi: csiostor: Enable lock context analysis
      scsi: elx: Enable lock context analysis
      scsi: esas2r: Enable lock context analysis
      scsi: fcoe: Enable lock context analysis
      scsi: fnic: Pass pointers directly to several functions
      scsi: fnic: Enable lock context analysis
      scsi: hisi_sas: Enable lock context analysis
      scsi: hpsa: Prepare for enabling lock context analysis
      scsi: ibmvscsi: Enable lock context analysis
      scsi: ibmvscsi_tgt: Enable lock context analysis
      scsi: ipr: Simplify ipr_eh_abort()
      scsi: ipr: Pass the host pointer directly to several functions
      scsi: ipr: Prepare for enabling lock context analysis
      scsi: ips: Prepare for enabling lock context analysis
      scsi: isci: Enable lock context analysis
      scsi: libfc: Enable lock context analysis
      scsi: libsas: Prepare for enabling lock context analysis
      scsi: libsas: Enable lock context analysis
      scsi: lpfc: Prepare for enabling lock context analysis
      scsi: mpt3sas: Enable lock context analysis
      scsi: mvsas: Enable lock context analysis
      scsi: pcmcia: Enable lock context analysis
      scsi: pm8001: Enable lock context analysis
      scsi: qedf: Enable lock context analysis
      scsi: qedi: Enable lock context analysis
      scsi: qla1280: Pass the host pointer directly to several functions
      scsi: qla1280: Prepare for enabling lock context analysis
      scsi: qla2xxx: Enable lock context analysis
      scsi: qla4xxx: Enable lock context analysis
      scsi: iSCSI transport: Prepare for enabling lock context analysis
      scsi: smartpqi: Enable lock context analysis
      scsi: snic: Enable lock context analysis
      scsi: sym53c8xx_2: Enable lock context analysis
      scsi: drivers: Enable lock context analysis
      scsi: core: Document the role of scsi_done()
      scsi: ipr: Fix two kernel-doc comments
      scsi: fnic: Annotate fnic_nvme functions with __must_hold()
      scsi: sd: Mark the disk dead if runtime resume fails in sd_remove()

Bean Huo (1):
      scsi: MAINTAINERS: Add Bean Huo and Stanley Jhu as UFS reviewers

Eric Biggers (1):
      scsi: target: iscsi: Use crypto library API

Haotian Zhang (1):
      scsi: elx: libefc: Fix resource leak in efcport_init() error path

Joonhoe Kim (1):
      scsi: ufs: core: Fix a deadlock between clock scaling and device comm=
ands

Karan Tilak Kumar (1):
      scsi: fnic: Update module authors

Laurence Oberman (1):
      scsi: st: MAINTAINERS: Add Laurence Oberman and John Meneghini

Martin K. Petersen (Oracle) (6):
      Merge patch series "scsi_debug: Enable lock context analysis"
      Merge patch series "lpfc: Update lpfc to revision 15.0.0.1"
      Merge patch series "scsi: Enable context analysis for most drivers"
      Merge branch '7.3/scsi-fixes' into 7.4/scsi-staging
      Merge patch series "scsi: ufs: Fix UIC result byte and BSG request ha=
ndlin
g"
      Merge patch series "scsi: ufs: core: Factor hba->outstanding_reqs hel=
per a
nd fix double completions"

Nigel Kirkland (8):
      scsi: lpfc: Fix use-after-free in lpfc_cmpl_ct_cmd_vmid()
      scsi: lpfc: Early return out of lpfc_els_abort() when HBA_SETUP flag =
is no
t set
      scsi: lpfc: Fix kernel oops when unmapping SCSI DMA buffers for an ab=
orted
 cmd
      scsi: lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDIS=
C err
or
      scsi: lpfc: Rework I/O flush ordering when unloading driver
      scsi: lpfc: Refactor calls on fc_disctmo to lpfc_set_disctmo in RSCN =
handl
er
      scsi: lpfc: Update correct ndlp refcnt when rejecting an unsolicited =
PLOGI
      scsi: lpfc: Update lpfc version to 15.0.0.1

Nilesh Javali (1):
      scsi: MAINTAINERS: Update Marvell Ethernet storage maintainers

Pradeep P V K (2):
      scsi: dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Document Glymur QM=
P UFS
 PHY
      scsi: ufs: qcom: dt-bindings: Document Glymur UFS controller

Randy Dunlap (1):
      scsi: core: Update cdrom.h coments

Ratnaker Gautam (1):
      scsi: libiscsi_tcp: Prevent R2T range check overflow

Shawn Lin (1):
      scsi: ufs: core: Fix stale comment in ufshcd_mcq_config_nr_queues()

Stanley Jhu (12):
      scsi: ufs: docs: Describe how to test with QEMU
      scsi: ufs: bsg: Complete the job on error
      scsi: ufs: bsg: Clear the reply buffer before use
      scsi: ufs: bsg: Validate request_len before accessing request
      scsi: ufs: bsg: Reject UIC commands with a non-zero result byte
      scsi: ufs: core: Clear stale UIC result byte before peer DME retries
      scsi: ufs: core: Remove an always-false WARN_ONCE()
      scsi: ufs: core: Add a helper for clearing hba->outstanding_reqs
      scsi: ufs: core: Fix double completion in ufshcd_clear_lu_cmds()
      scsi: ufs: core: Fix double release in ufshcd_eh_timed_out()
      scsi: ufs: core: Remove completed-without-interrupt path in ufshcd_ab=
ort()
      scsi: ufs: core: Do not release a reserved request in ufshcd_abort()

Xingui Yang (4):
      scsi: libsas: Fix out-of-bounds memcpy() in sas_ssp_task_response()
      scsi: hisi_sas: Fix incorrect delay values from magic-number cleanup
      scsi: hisi_sas: Clear PHY error counts on phyup
      scsi: hisi_sas: Fix spinup failure for SAS SSP devices in Active_Wait=
 stat
e

Yingjie Wang (1):
      scsi: handle out-of-range SG_SET_TIMEOUT values

 .../bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml    |   3 +
 .../devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml |   3 +
 Documentation/scsi/ufs.rst                         |  38 ++
 MAINTAINERS                                        |  23 +-
 block/bsg.c                                        |   5 +-
 drivers/infiniband/ulp/iser/iser_initiator.c       |   3 +-
 drivers/scsi/Makefile                              |  25 +-
 drivers/scsi/NCR5380.c                             |  19 +-
 drivers/scsi/NCR5380.h                             |   5 +-
 drivers/scsi/aacraid/Makefile                      |   2 +
 drivers/scsi/aacraid/commctrl.c                    |   1 +
 drivers/scsi/aacraid/commsup.c                     |   3 +
 drivers/scsi/aha152x.c                             |   4 +-
 drivers/scsi/aic7xxx/Makefile                      |   2 +
 drivers/scsi/aic7xxx/aic79xx_osm.h                 |   2 +
 drivers/scsi/aic7xxx/aic7xxx_osm.h                 |   2 +
 drivers/scsi/aic94xx/Makefile                      |   2 +
 drivers/scsi/arcmsr/Makefile                       |   2 +
 drivers/scsi/be2iscsi/Makefile                     |   2 +
 drivers/scsi/be2iscsi/be_main.c                    |  18 +-
 drivers/scsi/bfa/Makefile                          |   3 +
 drivers/scsi/bnx2fc/Makefile                       |   3 +
 drivers/scsi/bnx2fc/bnx2fc.h                       |   9 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c                   |  27 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                   |   2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                    |  15 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c                   |   2 +-
 drivers/scsi/bnx2i/Makefile                        |   3 +
 drivers/scsi/bnx2i/bnx2i_hwi.c                     |  45 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |   1 +
 drivers/scsi/csiostor/Makefile                     |   2 +
 drivers/scsi/csiostor/csio_attr.c                  |   4 +-
 drivers/scsi/csiostor/csio_hw.c                    |  20 +-
 drivers/scsi/csiostor/csio_lnode.c                 |   3 +
 drivers/scsi/csiostor/csio_rnode.c                 |   9 +-
 drivers/scsi/csiostor/csio_scsi.c                  |  42 +-
 drivers/scsi/csiostor/csio_scsi.h                  |   7 +-
 drivers/scsi/cxgbi/Makefile                        |   3 +
 drivers/scsi/cxgbi/libcxgbi.c                      |  13 +-
 drivers/scsi/elx/Makefile                          |   1 +
 drivers/scsi/elx/libefc/efclib.c                   |   2 +
 drivers/scsi/esas2r/Makefile                       |   3 +
 drivers/scsi/fcoe/Makefile                         |   3 +
 drivers/scsi/fcoe/fcoe_ctlr.c                      |  50 ++-
 drivers/scsi/fnic/Makefile                         |   3 +
 drivers/scsi/fnic/fdls_disc.c                      |  57 ++-
 drivers/scsi/fnic/fip.c                            |   2 +
 drivers/scsi/fnic/fnic.h                           |   2 +-
 drivers/scsi/fnic/fnic_fcs.c                       |  21 +-
 drivers/scsi/fnic/fnic_fdls.h                      |   7 +-
 drivers/scsi/fnic/fnic_main.c                      |   7 +-
 drivers/scsi/fnic/fnic_nvme.c                      |   4 +
 drivers/scsi/fnic/fnic_scsi.c                      |   4 +
 drivers/scsi/hisi_sas/Makefile                     |   3 +
 drivers/scsi/hisi_sas/hisi_sas.h                   |   3 +
 drivers/scsi/hisi_sas/hisi_sas_main.c              |  43 ++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |   4 +
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |   4 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  51 ++-
 drivers/scsi/hpsa.c                                |   2 +-
 drivers/scsi/ibmvscsi/Makefile                     |   3 +
 drivers/scsi/ibmvscsi_tgt/Makefile                 |   3 +
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c           |  34 +-
 drivers/scsi/ipr.c                                 |  50 ++-
 drivers/scsi/ips.c                                 |   1 +
 drivers/scsi/isci/Makefile                         |   3 +
 drivers/scsi/libfc/Makefile                        |   2 +
 drivers/scsi/libfc/fc_disc.c                       |   7 +-
 drivers/scsi/libfc/fc_exch.c                       |   6 +
 drivers/scsi/libfc/fc_fcp.c                        |  17 +-
 drivers/scsi/libiscsi.c                            | 258 +++++++-----
 drivers/scsi/libiscsi_tcp.c                        |  20 +-
 drivers/scsi/libsas/Makefile                       |   2 +
 drivers/scsi/libsas/sas_ata.c                      |   2 +-
 drivers/scsi/libsas/sas_task.c                     |   2 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |   2 -
 drivers/scsi/lpfc/lpfc_els.c                       |  82 ++--
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   7 +
 drivers/scsi/lpfc/lpfc_init.c                      |  16 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |  31 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |   1 +
 drivers/scsi/lpfc/lpfc_sli.c                       |  10 +-
 drivers/scsi/lpfc/lpfc_version.h                   |   2 +-
 drivers/scsi/mpt3sas/Makefile                      |   3 +
 drivers/scsi/mvsas/Makefile                        |   2 +
 drivers/scsi/mvsas/mv_sas.c                        |   7 +
 drivers/scsi/pcmcia/Makefile                       |   2 +
 drivers/scsi/pm8001/Makefile                       |   1 +
 drivers/scsi/pm8001/pm80xx_hwi.c                   |   2 +
 drivers/scsi/qedf/Makefile                         |   3 +
 drivers/scsi/qedi/Makefile                         |   3 +
 drivers/scsi/qedi/qedi_fw.c                        |  35 +-
 drivers/scsi/qla1280.c                             |  57 ++-
 drivers/scsi/qla2xxx/Makefile                      |   3 +
 drivers/scsi/qla2xxx/qla_nx.c                      |   2 +
 drivers/scsi/qla2xxx/qla_target.c                  |  29 +-
 drivers/scsi/qla2xxx/qla_tmpl.c                    |   1 +
 drivers/scsi/qla4xxx/Makefile                      |   3 +
 drivers/scsi/qla4xxx/ql4_isr.c                     |   8 +-
 drivers/scsi/qla4xxx/ql4_nx.c                      |   2 +
 drivers/scsi/scsi_debug.c                          | 454 +++++++++++++----=
----
 drivers/scsi/scsi_ioctl.c                          |  11 +-
 drivers/scsi/scsi_lib.c                            |  14 +
 drivers/scsi/scsi_transport_iscsi.c                |   1 +
 drivers/scsi/sd.c                                  |  10 +-
 drivers/scsi/sg.c                                  |   1 +
 drivers/scsi/smartpqi/Makefile                     |   3 +
 drivers/scsi/smartpqi/smartpqi_init.c              |  67 ++-
 drivers/scsi/snic/Makefile                         |   3 +
 drivers/scsi/st.c                                  |   1 +
 drivers/scsi/sym53c8xx_2/Makefile                  |   2 +
 drivers/target/iscsi/Kconfig                       |   7 +-
 drivers/target/iscsi/iscsi_target_auth.c           | 192 ++++-----
 drivers/target/iscsi/iscsi_target_auth.h           |   8 +-
 drivers/ufs/core/ufs-mcq.c                         |   4 +-
 drivers/ufs/core/ufs_bsg.c                         |  23 +-
 drivers/ufs/core/ufshcd.c                          |  91 +++--
 drivers/ufs/host/ufs-qcom.c                        |   9 +-
 include/linux/pci.h                                |   5 +-
 include/scsi/libiscsi.h                            |  23 +-
 include/scsi/scsi.h                                |   2 +-
 121 files changed, 1528 insertions(+), 780 deletions(-)

Regards,

James
