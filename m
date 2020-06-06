Return-Path: <SRS0=2jUW=7T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D756BC433DF
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Jun 2020 23:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B235E207C4
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Jun 2020 23:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbgFFXU6 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Jun 2020 19:20:58 -0400
Received: from mga06.intel.com ([134.134.136.31]:21233 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728479AbgFFXU5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 6 Jun 2020 19:20:57 -0400
IronPort-SDR: HlWn9kk24lSYkG4M4oypZmDK1a6q9Q8x6spKvnCiqQgCz3K8h8dITL9FGuQPOxHKNYZNbX4kXz
 tGJ7pX1H/OHQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2020 16:20:52 -0700
IronPort-SDR: ti0jvJLpGcgLyivV4rGyGGTAd4EL7uaOFyxLjmxnunkK0gCGCEjCcju7bcu7vpY6eLJE8GLH2L
 aHQrjgrwqLiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,482,1583222400"; 
   d="scan'208";a="446311414"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga005.jf.intel.com with ESMTP; 06 Jun 2020 16:20:52 -0700
Received: from lcsmsx603.ger.corp.intel.com (10.109.210.12) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 6 Jun 2020 16:20:52 -0700
Received: from hasmsx602.ger.corp.intel.com (10.184.107.142) by
 LCSMSX603.ger.corp.intel.com (10.109.210.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 7 Jun 2020 02:20:49 +0300
Received: from hasmsx602.ger.corp.intel.com ([10.184.107.142]) by
 HASMSX602.ger.corp.intel.com ([10.184.107.142]) with mapi id 15.01.1713.004;
 Sun, 7 Jun 2020 02:20:49 +0300
From:   "Winkler, Tomas" <tomas.winkler@intel.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 1/2] scsi: ufs: Add SPDX GPL-2.0 to replace GPL v2
 boilerplate
Thread-Topic: [PATCH v3 1/2] scsi: ufs: Add SPDX GPL-2.0 to replace GPL v2
 boilerplate
Thread-Index: AQHWO3S8UoN7m4BGoEOt/WDIdsv7Y6jMOuqg
Date:   Sat, 6 Jun 2020 23:20:49 +0000
Message-ID: <b9f2970c5061433b8acc16a10885e5b4@intel.com>
References: <20200605200520.20831-1-huobean@gmail.com>
 <20200605200520.20831-2-huobean@gmail.com>
In-Reply-To: <20200605200520.20831-2-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
x-originating-ip: [10.184.70.1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> 
> From: Bean Huo <beanhuo@micron.com>
> 
> Add SPDX GPL-2.0 to UFS driver files that specified the GPL version 2 license,
> remove the full boilerplate text.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
LGTM.
Thanks
Tomas

> ---
>  drivers/scsi/ufs/ufs.h           | 27 +--------------------------
>  drivers/scsi/ufs/ufshcd-pci.c    | 25 +------------------------
>  drivers/scsi/ufs/ufshcd-pltfrm.c | 27 +--------------------------
>  drivers/scsi/ufs/ufshcd.c        | 30 +-----------------------------
>  drivers/scsi/ufs/ufshcd.h        | 27 +--------------------------
>  drivers/scsi/ufs/ufshci.h        | 27 +--------------------------
>  6 files changed, 6 insertions(+), 157 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h index
> c70845d41449..7df4bdc813d6 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -1,36 +1,11 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>  /*
>   * Universal Flash Storage Host controller driver
> - *
> - * This code is based on drivers/scsi/ufs/ufs.h
>   * Copyright (C) 2011-2013 Samsung India Software Operations
>   *
>   * Authors:
>   *	Santosh Yaraganavi <santosh.sy@samsung.com>
>   *	Vinayak Holikatti <h.vinayak@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - * See the COPYING file in the top-level directory or visit
> - * <http://www.gnu.org/licenses/gpl-2.0.html>
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * This program is provided "AS IS" and "WITH ALL FAULTS" and
> - * without warranty of any kind. You are solely responsible for
> - * determining the appropriateness of using and distributing
> - * the program and assume all risks associated with your exercise
> - * of rights with respect to the program, including but not limited
> - * to infringement of third party rights, the risks and costs of
> - * program errors, damage to or loss of data, programs or equipment,
> - * and unavailability or interruption of operations. Under no
> - * circumstances will the contributor of this Program be liable for
> - * any damages of any kind arising from your use or distribution of
> - * this program.
>   */
> 
>  #ifndef _UFS_H
> diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c index
> 8f78a8151499..f407b13883ac 100644
> --- a/drivers/scsi/ufs/ufshcd-pci.c
> +++ b/drivers/scsi/ufs/ufshcd-pci.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
>  /*
>   * Universal Flash Storage Host controller PCI glue driver
>   *
> @@ -7,30 +8,6 @@
>   * Authors:
>   *	Santosh Yaraganavi <santosh.sy@samsung.com>
>   *	Vinayak Holikatti <h.vinayak@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - * See the COPYING file in the top-level directory or visit
> - * <http://www.gnu.org/licenses/gpl-2.0.html>
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * This program is provided "AS IS" and "WITH ALL FAULTS" and
> - * without warranty of any kind. You are solely responsible for
> - * determining the appropriateness of using and distributing
> - * the program and assume all risks associated with your exercise
> - * of rights with respect to the program, including but not limited
> - * to infringement of third party rights, the risks and costs of
> - * program errors, damage to or loss of data, programs or equipment,
> - * and unavailability or interruption of operations. Under no
> - * circumstances will the contributor of this Program be liable for
> - * any damages of any kind arising from your use or distribution of
> - * this program.
>   */
> 
>  #include "ufshcd.h"
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
> index 76f9be71c31b..3db0af66c71c 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -1,36 +1,11 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
>  /*
>   * Universal Flash Storage Host controller Platform bus based glue driver
> - *
> - * This code is based on drivers/scsi/ufs/ufshcd-pltfrm.c
>   * Copyright (C) 2011-2013 Samsung India Software Operations
>   *
>   * Authors:
>   *	Santosh Yaraganavi <santosh.sy@samsung.com>
>   *	Vinayak Holikatti <h.vinayak@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - * See the COPYING file in the top-level directory or visit
> - * <http://www.gnu.org/licenses/gpl-2.0.html>
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * This program is provided "AS IS" and "WITH ALL FAULTS" and
> - * without warranty of any kind. You are solely responsible for
> - * determining the appropriateness of using and distributing
> - * the program and assume all risks associated with your exercise
> - * of rights with respect to the program, including but not limited
> - * to infringement of third party rights, the risks and costs of
> - * program errors, damage to or loss of data, programs or equipment,
> - * and unavailability or interruption of operations. Under no
> - * circumstances will the contributor of this Program be liable for
> - * any damages of any kind arising from your use or distribution of
> - * this program.
>   */
> 
>  #include <linux/platform_device.h>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> ad4fc829cbb2..ec4f55211648 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1,40 +1,12 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
>  /*
>   * Universal Flash Storage Host controller driver Core
> - *
> - * This code is based on drivers/scsi/ufs/ufshcd.c
>   * Copyright (C) 2011-2013 Samsung India Software Operations
>   * Copyright (c) 2013-2016, The Linux Foundation. All rights reserved.
>   *
>   * Authors:
>   *	Santosh Yaraganavi <santosh.sy@samsung.com>
>   *	Vinayak Holikatti <h.vinayak@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - * See the COPYING file in the top-level directory or visit
> - * <http://www.gnu.org/licenses/gpl-2.0.html>
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * This program is provided "AS IS" and "WITH ALL FAULTS" and
> - * without warranty of any kind. You are solely responsible for
> - * determining the appropriateness of using and distributing
> - * the program and assume all risks associated with your exercise
> - * of rights with respect to the program, including but not limited
> - * to infringement of third party rights, the risks and costs of
> - * program errors, damage to or loss of data, programs or equipment,
> - * and unavailability or interruption of operations. Under no
> - * circumstances will the contributor of this Program be liable for
> - * any damages of any kind arising from your use or distribution of
> - * this program.
> - *
> - * The Linux Foundation chooses to take subject only to the GPLv2
> - * license terms, and distributes only under these terms.
>   */
> 
>  #include <linux/async.h>
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
> bf97d616e597..ef92c4a9e378 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -1,37 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>  /*
>   * Universal Flash Storage Host controller driver
> - *
> - * This code is based on drivers/scsi/ufs/ufshcd.h
>   * Copyright (C) 2011-2013 Samsung India Software Operations
>   * Copyright (c) 2013-2016, The Linux Foundation. All rights reserved.
>   *
>   * Authors:
>   *	Santosh Yaraganavi <santosh.sy@samsung.com>
>   *	Vinayak Holikatti <h.vinayak@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - * See the COPYING file in the top-level directory or visit
> - * <http://www.gnu.org/licenses/gpl-2.0.html>
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * This program is provided "AS IS" and "WITH ALL FAULTS" and
> - * without warranty of any kind. You are solely responsible for
> - * determining the appropriateness of using and distributing
> - * the program and assume all risks associated with your exercise
> - * of rights with respect to the program, including but not limited
> - * to infringement of third party rights, the risks and costs of
> - * program errors, damage to or loss of data, programs or equipment,
> - * and unavailability or interruption of operations. Under no
> - * circumstances will the contributor of this Program be liable for
> - * any damages of any kind arising from your use or distribution of
> - * this program.
>   */
> 
>  #ifndef _UFSHCD_H
> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h index
> c2961d37cc1c..2c1c7a277430 100644
> --- a/drivers/scsi/ufs/ufshci.h
> +++ b/drivers/scsi/ufs/ufshci.h
> @@ -1,36 +1,11 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>  /*
>   * Universal Flash Storage Host controller driver
> - *
> - * This code is based on drivers/scsi/ufs/ufshci.h
>   * Copyright (C) 2011-2013 Samsung India Software Operations
>   *
>   * Authors:
>   *	Santosh Yaraganavi <santosh.sy@samsung.com>
>   *	Vinayak Holikatti <h.vinayak@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - * See the COPYING file in the top-level directory or visit
> - * <http://www.gnu.org/licenses/gpl-2.0.html>
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * This program is provided "AS IS" and "WITH ALL FAULTS" and
> - * without warranty of any kind. You are solely responsible for
> - * determining the appropriateness of using and distributing
> - * the program and assume all risks associated with your exercise
> - * of rights with respect to the program, including but not limited
> - * to infringement of third party rights, the risks and costs of
> - * program errors, damage to or loss of data, programs or equipment,
> - * and unavailability or interruption of operations. Under no
> - * circumstances will the contributor of this Program be liable for
> - * any damages of any kind arising from your use or distribution of
> - * this program.
>   */
> 
>  #ifndef _UFSHCI_H
> --
> 2.17.1

