Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD120C43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 23:17:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A12F20866
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 23:17:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SAI8ANVd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfLTXRU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 18:17:20 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33368 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfLTXRU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 18:17:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ElIL1z77XbbIvi9sWMvIxoQjHMDg1lfERWRslYE+TPY=; b=SAI8ANVdTvznlGRCQcJ8rwJhb
        CjMyUcpcocNdDCbefTULwPX6/pZ9Mf4w8UrNUZ53rp4mblQVw66bVm1OYzaGZ7bmBRtUcV2tAAMBm
        if+kzvk8jqXT4E41WbyduL+4kbDj80WOJt65hCoyJtboH2CGlpxYhfoqeGeJWJgvbuCL6aj1Vxp3U
        KY5WA+iRIRqwrlZ+HMNgfAJIzwSRsMzOPAC9KY+G/iAueId/92iBwTISz+Kl50RrDGQM2B96AbN7x
        /L8MWREpwWxv2jVgrDOQEjae1pGLgqhL9o7cK5gHvGgyJxvchZfcndhaqg9mMUUpVQGBAdAIyyEGG
        PkQbf/rrg==;
Received: from [2601:1c0:6280:3f0::fee9]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iiRWG-0003w0-LB; Fri, 20 Dec 2019 23:17:16 +0000
Subject: Re: [PATCH v2 31/32] elx: efct: Add Makefile and Kconfig for efct
 driver
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-32-jsmart2021@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <9cc2c2b2-8d59-accd-b7d2-dcb433a27345@infradead.org>
Date:   Fri, 20 Dec 2019 15:17:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191220223723.26563-32-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/20/19 2:37 PM, James Smart wrote:
> diff --git a/drivers/scsi/elx/Kconfig b/drivers/scsi/elx/Kconfig
> new file mode 100644
> index 000000000000..ec710ade44f3
> --- /dev/null
> +++ b/drivers/scsi/elx/Kconfig
> @@ -0,0 +1,9 @@
> +config SCSI_EFCT
> +	tristate "Emulex Fibre Channel Target"
> +	depends on PCI && SCSI
> +	depends on TARGET_CORE
> +	depends on SCSI_FC_ATTRS
> +	select CRC_T10DIF
> +	help
> +          The efct driver provides enhanced SCSI Target Mode

Use tab + 2 spaces above, instead of all spaces, please.

> +	  support for specific SLI-4 adapters.


-- 
~Randy

