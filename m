Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C19ADC3DA40
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 08:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbjHBIs0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 04:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbjHBIsX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 04:48:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29339D9;
        Wed,  2 Aug 2023 01:48:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B26286189A;
        Wed,  2 Aug 2023 08:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F6CC433C7;
        Wed,  2 Aug 2023 08:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690966102;
        bh=NDDryVv8WBs0MrakH/XEpeVn2udcnM0LHCwQ2rX07B8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=uMyku//1pacFt9LpwUB0r8zxXKdB5I6hOagla3nvty672sZx4D781sIGkzvsCfjkb
         omvqNn1i95aRWrwiBPMAeFNNarI0WUfzuvIVaIBquVLMkPKgQKZXspjXefn+pNcRkW
         I9b9KJhU5+0nbviC/ufnETVn0O5Ss98YJ9wtDYtiMoryVpK/I1S0y2p0oF8Ck6Famd
         D9Tamj1OUMhLwkfi42vPQyG9Z7WC7nNo4YFqQ5HDBf0UDiysl9LALiwqQMLFnQOp1K
         Atp1Re/aVOzywGkviOYqw6wElCjzEFbvvaDjbem6hAClX05VNOPU3hqggoQSFRj9Fa
         pRjveql2JIzCw==
Message-ID: <789fb6b3-e871-3c4e-d3d5-b8c3ece1624a@kernel.org>
Date:   Wed, 2 Aug 2023 17:48:04 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 00/10] libata: remove references to 'old' error handler
Content-Language: en-US
To:     Niklas Cassel <nks@flawful.org>, Jonathan Corbet <corbet@lwn.net>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        linux-doc@vger.kernel.org
References: <20230731143432.58886-1-nks@flawful.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230731143432.58886-1-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/31/23 23:34, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Hi all,
> 
> now that the ipr driver has been modified to not hook into libata
> all drivers now use the 'new' error handler, so we can remove any
> references to it. And do a general cleanup to remove callbacks
> which are no longer needed.
> 
> Damien:
> This patch series is based on v6.5-rc4, however it also applies to your
> libata/for-next branch, if you cherry-pick commit 3ac873c76d79 ("ata:
> libata-core: fix when to fetch sense data for successful commands"),
> before applying the series (this patch is already in Torvald's tree).

Applied to for-6.6 with some tweaks to the commit titles.
Thanks !

-- 
Damien Le Moal
Western Digital Research

