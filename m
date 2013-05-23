From: Vijay Mohan Guvva <vmohan@Brocade.com>
Subject: RE: [PATCH V1 00/17] Update the driver version to 3.2.21.1
Date: Thu, 23 May 2013 04:55:22 -0600
Message-ID: <51BD2AE8016AE441B63F5661159C99020F1DF1879A@BRM-EXCH-3.corp.brocade.com>
References: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:57685 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758168Ab3EWLCE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 May 2013 07:02:04 -0400
Received: from pps.filterd (m0000542 [127.0.0.1])
	by mx0a-000f0801.pphosted.com (8.14.5/8.14.5) with SMTP id r4NAuGiO003374
	for <linux-scsi@vger.kernel.org>; Thu, 23 May 2013 04:02:02 -0700
Received: from brmwp-exchub01.corp.brocade.com ([208.47.132.227])
	by mx0a-000f0801.pphosted.com with ESMTP id 1chhsf8029-4
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 23 May 2013 04:02:02 -0700
In-Reply-To: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "JBottomley@parallels.com" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.COM>

> -----Original Message-----
> From: Vijay Mohan Guvva
> Sent: Monday, May 13, 2013 3:03 PM
> To: linux-scsi@vger.kernel.org
> Cc: JBottomley@parallels.com; Adapter Linux Open SRC Team; Vijay Mohan
> Guvva
> Subject: [PATCH V1 00/17] Update the driver version to 3.2.21.1
> 
> Hi James,
> Re-submitting the patch sets, Update the driver version to 3.2.21.0 and
> Update the driver version to 3.2.21.1.
> It includes bug-fixes, changes to use firmware version 3.2.1.0, adds new
> features such as Forward Error Correction, FC BB credit recovery, dynamic
> diagnostic Port (D-port), enabled support for new hardware - chinook quad
> and updates the Brocade BFA driver to v3.2.21.1.
> 
> Thanks,
> Vijaya Mohan Guvva
> 
> Vijaya Mohan Guvva (17):
>   bfa: Support for FC BB credit recovery
>   bfa: Forward Error Correction status query
>   bfa: Add dynamic diagnostic port support
>   bfa: Fix WARN_ON condition check
>   bfa: FDMI enhancements
>   bfa: Fix 1860 port initialize when ATC is enabled
>   bfa: Fix FDISC timeout handling
>   bfa: kdump fix on 815 and 825 adapters
>   bfa: driver compatibility with 32bit libs
>   bfa: fru vpd date update changes
>   bfa: firmware statistics update
>   bfa: Allow rsp queue process during ioc disable
>   bfa: Fix bug_on condition in RPSC rsp handling
>   bfa: fix endianess issue for firmware stats
>   bfa: Support for chinook-quad port card
>   bfa: dis-associate bfa path_tov with dev_loss_tmo
>   bfa: Update the driver version to 3.2.21.1
> 
>  drivers/scsi/bfa/bfa_core.c      |   3 +-
>  drivers/scsi/bfa/bfa_defs.h      | 103 +++++-
>  drivers/scsi/bfa/bfa_defs_svc.h  |  77 ++++-
>  drivers/scsi/bfa/bfa_fc.h        |  15 +
>  drivers/scsi/bfa/bfa_fcpim.c     |   2 +-
>  drivers/scsi/bfa/bfa_fcs.c       |  62 +---
>  drivers/scsi/bfa/bfa_fcs.h       |  34 +-
>  drivers/scsi/bfa/bfa_fcs_lport.c | 209 +++++++++++-
>  drivers/scsi/bfa/bfa_fcs_rport.c |   7 +-
>  drivers/scsi/bfa/bfa_ioc.c       |  74 +++--
>  drivers/scsi/bfa/bfa_ioc.h       |   9 +-
>  drivers/scsi/bfa/bfa_ioc_cb.c    |  86 ++++-
>  drivers/scsi/bfa/bfa_ioc_ct.c    |  46 +++
>  drivers/scsi/bfa/bfa_svc.c       | 698
> ++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/bfa/bfa_svc.h       |  34 +-
>  drivers/scsi/bfa/bfad.c          |  14 +-
>  drivers/scsi/bfa/bfad_attr.c     |  33 +-
>  drivers/scsi/bfa/bfad_bsg.c      | 137 +++++---
>  drivers/scsi/bfa/bfad_bsg.h      |  52 ++-
>  drivers/scsi/bfa/bfad_drv.h      |   2 +-
>  drivers/scsi/bfa/bfi.h           |  78 ++++-
>  drivers/scsi/bfa/bfi_ms.h        |   5 +-
>  22 files changed, 1498 insertions(+), 282 deletions(-)
> 
> --
> 1.7.12

> The patch you're replying to didn't make the list, which is also a necessary precursor to getting stuff into the tree.

Hi James,
I have resubmitted the patch set and verified them in MARC.
Please pull the set if you don't have any comments.

Thanks,
Vijay
