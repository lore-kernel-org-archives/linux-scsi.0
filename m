From: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 4/5] ata: Add APM X-Gene SATA serdes functions
Date: Fri, 8 Nov 2013 16:38:21 -0800
Message-ID: <20131109003821.GA22982@quad.lixom.net>
References: <1383949838-25106-1-git-send-email-lho@apm.com>
 <1383949838-25106-2-git-send-email-lho@apm.com>
 <1383949838-25106-3-git-send-email-lho@apm.com>
 <1383949838-25106-4-git-send-email-lho@apm.com>
 <1383949838-25106-5-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34033 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757457Ab3KIAks (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2013 19:40:48 -0500
Received: by mail-pa0-f42.google.com with SMTP id kp14so2946354pab.29
        for <linux-scsi@vger.kernel.org>; Fri, 08 Nov 2013 16:40:47 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1383949838-25106-5-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: tj@kernel.org, linux-scsi@vger.kernel.org, Suman Tripathi <stripathi@apm.com>, jcm@redhat.com, devicetree-discuss@lists.ozlabs.org, patches@apm.com, Tuan Phan <tphan@apm.com>, linux-arm-kernel@lists.infradead.org

On Fri, Nov 08, 2013 at 03:30:37PM -0700, Loc Ho wrote:
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Tuan Phan <tphan@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>  drivers/ata/sata_xgene_serdes.c | 1982 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 1982 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/ata/sata_xgene_serdes.c

To start with:

This patch is riddled with checkpatch errors from whitespace stuff.

It completely lacks any kind of patch description.


-Olof
