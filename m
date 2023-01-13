Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0BCC677F1
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Jan 2023 18:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbjAMS1E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Jan 2023 13:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbjAMS0P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2023 13:26:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0147DE30;
        Fri, 13 Jan 2023 10:21:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59CDCB82196;
        Fri, 13 Jan 2023 18:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F79C433EF;
        Fri, 13 Jan 2023 18:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673634115;
        bh=wgQJUKdJiGKKA14S47GMRE1JaKpLXL4mOsb55g2FXfs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LHqcZJFW7FFOU7mLmtzcZc65vV/jG1OheZkgWG+nZpLF5a07vabcsa0W0mPknD3W3
         6piXoExjwVwNJw3NeMYKekgT+lk8/1DLKu5/bkstfoTPaZvXU64xovijcaDiYUiGFk
         Rd5NfpqWMTaFCEjuCoT4QWGZQrhR0QzI8HxMF6+tvslQKZL5Nolf5pGHRYV/6vqPBE
         OAmUqnXJl7IRRbEMMbzfI4/n7i4UkTj6uLVdI2N7K3bEp0pT9HT+IZznwylpQX8yzE
         565XcMR2/LpYlaptp1l9ZR7anl1/iXPvalchvrmWsWh4soIqdSi9T63jQF7Be7Fqz8
         dhDa/4nB1pHcA==
Date:   Fri, 13 Jan 2023 23:51:50 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Lux Aliaga <they@mint.lgbt>
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        kishon@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, keescook@chromium.org, tony.luck@intel.com,
        gpiccoli@igalia.com, ~postmarketos/upstreaming@lists.sr.ht,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-hardening@vger.kernel.org,
        phone-devel@vger.kernel.org, martin.botka@somainline.org,
        marijn.suijten@somainline.org
Subject: Re: [PATCH v6 3/6] phy: qcom-qmp: Add SM6125 UFS PHY support
Message-ID: <Y8GhPiRZxFZhhQuu@matsya>
References: <20230108195336.388349-1-they@mint.lgbt>
 <20230108195336.388349-4-they@mint.lgbt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230108195336.388349-4-they@mint.lgbt>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08-01-23, 16:53, Lux Aliaga wrote:
> The SM6125 UFS PHY is compatible with the one from SM6115. Add a
> compatible for it and modify the config from SM6115 to make them
> compatible with the SC8280XP binding

Applied, thanks

-- 
~Vinod
