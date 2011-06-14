From: Krishna Gudipati <kgudipat@Brocade.com>
Subject: RE: [PATCH 04/12] bfa: Brocade-1860 Fabric Adapter Hardware
 Enablement
Date: Tue, 14 Jun 2011 10:44:25 -0700
Message-ID: <B5EE62D80D50B84BB9E5174F7FCCE80A02BC1D1A@HQ1-EXCH02.corp.brocade.com>
References: <1308005435-9193-1-git-send-email-kgudipat@brocade.com>
 <1424874.obOgTWAhri@donald.sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:42260 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752281Ab1FNRom convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2011 13:44:42 -0400
In-Reply-To: <1424874.obOgTWAhri@donald.sf-tec.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jing Huang <huangj@Brocade.COM>, Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.COM>

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Rolf Eike Beer
Sent: Monday, June 13, 2011 11:18 PM
To: Krishna Gudipati
Cc: JBottomley@parallels.com; linux-scsi@vger.kernel.org; Jing Huang; Adapter Linux Open SRC Team
Subject: Re: [PATCH 04/12] bfa: Brocade-1860 Fabric Adapter Hardware Enablement

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

----

Thanks Eike for reviewing.

I have split the patch into 2 patches with the second patch just removing the deleted
files bfi_cbreg.h and bfi_ctreg.h as you mentioned.

	[PATCH 4a/12] bfa: Brocade-1860 Fabric Adapter Hardware Enablement
	[PATCH 4b/12] bfa: Remove unused bfi_cbreg.h and bfi_ctreg.h

Regarding some patches deserve their own patch - we tried to make each patch compilable
and also functional, so we could not split some of the hardware enablement patches.

Thanks,
Krishna.
