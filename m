Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A811C43381
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 15:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07CC02312F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 15:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405434AbhALPpQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 10:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728629AbhALPpQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 10:45:16 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA4DC061575;
        Tue, 12 Jan 2021 07:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=l14dJC5AhKsY3MiSPibwbmUFTP
        bBNZrt+HEK4MzxzFu3AmgGKD87aIImibORm3X+8/96rk+VgbjcGqnWa7N2PRaNyipPiV0fb7xVGuc
        GAXBpgnHxOVKDPpjdcl/6GudvTxYbbtqTvunPgnWjyrzUpUCiLCRB8ac9+g/CrmD/cTBG6wf6tucv
        s/3cIUg9VpUKeEnv8+no9NBll7ooPrgOQNqRHUIbjXhYSNpp8T4u4jZE/cJhGISuYsKHF9apO0asm
        Bhosv+s2s5iNu+56K7XyxmFgBLd71lcuGlvCN4V9rzmzt1Y7v42IsbHCu+s9lgKb4zRZScfKDPnoF
        S2NzvH4w==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kzLpi-004yZk-Od; Tue, 12 Jan 2021 15:43:49 +0000
Date:   Tue, 12 Jan 2021 15:43:46 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
Cc:     john.garry@huawei.com, artur.paszkiewicz@intel.com,
        bigeasy@linutronix.de, dwagner@suse.de, intel-linux-scu@intel.com,
        jejb@linux.ibm.com, jinpu.wang@cloud.ionos.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, tglx@linutronix.de, yanaijie@huawei.com
Subject: Re: [PATCH v3 02/19] scsi: libsas and users: Remove notifier
 indirection
Message-ID: <20210112154346.GA1185705@infradead.org>
References: <21eefa9b-7ff5-b418-6db4-7e0039c24473@huawei.com>
 <20210112130708.705792-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112130708.705792-1-a.darwish@linutronix.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
