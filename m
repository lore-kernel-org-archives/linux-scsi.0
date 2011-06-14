From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 04/12] bfa: Brocade-1860 Fabric Adapter Hardware Enablement
Date: Tue, 14 Jun 2011 08:18:17 +0200
Message-ID: <1424874.obOgTWAhri@donald.sf-tec.de>
References: <1308005435-9193-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1757231.3sqtQqq14U"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:57396 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab1FNGS0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2011 02:18:26 -0400
In-Reply-To: <1308005435-9193-1-git-send-email-kgudipat@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kgudipat@brocade.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, huangj@brocade.com, adapter_linux_open_src_team@brocade.com


--nextPart1757231.3sqtQqq14U
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

kgudipat@brocade.com wrote:
> From: Krishna Gudipati <kgudipat@brocade.com>
> 
> Change details:
> 	- Added support for Brocade-1860 Fabric Adapter.
> 	- Made changes to support single firmware image per asic type.
> 	- Combined bfi_cbreg.h and bfi_ctreg.h defines into bfi_reg.h with
> 	  only minimal defines used by host.
> 	- Added changes to setup CPE/RME Queue register offsets based on
> 	  firmware response.
> 	- Removed queue register offset initializations and added register offsets
> 	  to BFI config response message.
> 	- Added Brocade-1860 asic specific interrupt status definitions and
> 	  mailbox interfaces.
> 
> Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
> ---
>  drivers/scsi/bfa/bfa.h        |   14 +-
>  drivers/scsi/bfa/bfa_core.c   |  209 +++++++++-----
>  drivers/scsi/bfa/bfa_defs.h   |   13 +-
>  drivers/scsi/bfa/bfa_hw_cb.c  |   34 +--
>  drivers/scsi/bfa/bfa_hw_ct.c  |   75 ++----
>  drivers/scsi/bfa/bfa_ioc.c    |  144 ++++++---
>  drivers/scsi/bfa/bfa_ioc.h    |  117 +++++---
>  drivers/scsi/bfa/bfa_ioc_cb.c |   56 ++--
>  drivers/scsi/bfa/bfa_ioc_ct.c |  418 ++++++++++++++++++++++------
>  drivers/scsi/bfa/bfa_port.c   |    2 -
>  drivers/scsi/bfa/bfad.c       |   81 +++---
>  drivers/scsi/bfa/bfad_drv.h   |    1 +
>  drivers/scsi/bfa/bfad_im.c    |    2 +-
>  drivers/scsi/bfa/bfi.h        |   62 +++--
>  drivers/scsi/bfa/bfi_cbreg.h  |  305 --------------------
>  drivers/scsi/bfa/bfi_ctreg.h  |  636
> ----------------------------------------- drivers/scsi/bfa/bfi_ms.h     |  
> 36 +++
>  drivers/scsi/bfa/bfi_reg.h    |  428 +++++++++++++++++++++++++++
>  18 files changed, 1262 insertions(+), 1371 deletions(-)
>  delete mode 100644 drivers/scsi/bfa/bfi_cbreg.h
>  delete mode 100644 drivers/scsi/bfa/bfi_ctreg.h
>  create mode 100644 drivers/scsi/bfa/bfi_reg.h

[12k lines diff]

This patch is _way_ to big. And it's impossible to review. I suggest e.g. 
splitting the header merge things out of them so that these become a simple 
code move without any other changes. And some of the other patches likely 
deserve their own patch.

Eike
--nextPart1757231.3sqtQqq14U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk32/SoACgkQXKSJPmm5/E5L/wCgnm/L9Z6BB2lxwYjE5hLfyWEr
5H4An3qrs3TLxPOxbKSxMbhqJE1D97Bc
=qnOG
-----END PGP SIGNATURE-----

--nextPart1757231.3sqtQqq14U--

