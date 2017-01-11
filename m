From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 09/11] qla2xxx: Add Dual mode support in the driver
Date: Wed, 11 Jan 2017 11:51:46 -0800
Message-ID: <d04e3282-68b8-4541-58e8-ad972b069bfb@sandisk.com>
References: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
 <1482553419-4117-10-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0088.outbound.protection.outlook.com ([104.47.40.88]:3273
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751810AbdAKUHR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Jan 2017 15:07:17 -0500
In-Reply-To: <1482553419-4117-10-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, target-devel@vger.kernel.org, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org

On 12/23/2016 08:23 PM, Himanshu Madhani wrote:
> -#define QLA_TGT_MODE_ENABLED() (ql2x_ini_mode != QLA2XXX_INI_MODE_ENABLED)
> +#define QLA_TGT_MODE_ENABLED() \
> +	((ql2x_ini_mode != QLA2XXX_INI_MODE_ENABLED) || \
> +	 (ql2x_ini_mode == QLA2XXX_INI_MODE_DUAL))

Hello Himanshu and Quinn,

Is this change needed? It looks redundant to me. For all possible
ql2x_ini_mode values both the old and the new expression will yield the
same value.

Anyway, dual mode is a welcome improvement!

Bart.
