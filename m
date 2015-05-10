From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 3/3] ata: ahci_xgene: Add AHCI Support for 2nd HW
 version of APM X-Gene SoC AHCI SATA Host controller.
Date: Sun, 10 May 2015 11:54:54 -0400
Message-ID: <20150510155454.GD5856@htj.duckdns.org>
References: <1430853672-6227-1-git-send-email-stripathi@apm.com>
 <1430853672-6227-4-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:33887 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbbEJPy7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 May 2015 11:54:59 -0400
Content-Disposition: inline
In-Reply-To: <1430853672-6227-4-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com

Hello,

On Wed, May 06, 2015 at 12:51:12AM +0530, Suman Tripathi wrote:
> +	switch (version) {
> +	case XGENE_AHCI_V1:
> +		hpriv->flags = AHCI_HFLAG_NO_NCQ;
> +		/*
> +		 * Override the callbacks for storm ERRATA
> +		 */
> +		xgene_ahci_ops.qc_issue = xgene_ahci_qc_issue;
> +		xgene_ahci_ops.softreset = xgene_ahci_softreset;
> +		xgene_ahci_ops.pmp_softreset = xgene_ahci_pmp_softreset;

Let's please create separate ops structs for v1 and v2.

Thanks.

-- 
tejun
