Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 662EEC43334
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 18:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239863AbiGSSKN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 14:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbiGSSKL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 14:10:11 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887B3656A
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 11:10:09 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id w7so229465plp.5
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 11:10:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PN8Dabe9eXNfi/I34E/ssDxYHp+3I4Dvu+sdO1MEFdI=;
        b=EuevZ6XL3fNqtVM9P+F3gHyLbuYaEHxR4mMek3QRnuiXt0tTas+w+UgUYeofOunUcG
         kZmf6b9RgRJrqDpkQTETRVBGDISVKzHsIxTIwV82u+n+26Iv0v2waMtn8LhSARHhH1jD
         F9KidvF9Z7jsxj1oNbndvLjdz3xc7yVQFU1Q9FFy6NCk96VtkCyOe/h6k8eOL7TjBWf/
         5NsERitVN6GI6XgCbsV3+IWociBn2WhbUO6lyLTnzd7Yd8M7sr+XB+ZJn+lctb+ejLyR
         iHGmbmNFyQpDT1Z4hTo/fF7FWdyxpUbAzSSFivh47s5H+nw2RKrE9nGmVSxi1Uwa45Pm
         CV2w==
X-Gm-Message-State: AJIora/Ity9/UlEl5jRLyBt76qit1CbOmBnjCVMUnaaQoHNVzt347MSn
        WYl9N4yEQurC2X7mcYQyZJ4=
X-Google-Smtp-Source: AGRyM1savgRaouoA7s/eTu53KHJ5AfWCrvnWs3bNd8wGCy4m0VNQXSPIUUEHgwapAydpz99t1C8qJw==
X-Received: by 2002:a17:902:6b0a:b0:16c:38eb:b516 with SMTP id o10-20020a1709026b0a00b0016c38ebb516mr33963556plk.15.1658254208881;
        Tue, 19 Jul 2022 11:10:08 -0700 (PDT)
Received: from ?IPV6:2600:1010:b002:e126:5611:6026:69c2:37bc? ([2600:1010:b002:e126:5611:6026:69c2:37bc])
        by smtp.gmail.com with ESMTPSA id t7-20020a170902e84700b0016c1cdd2de3sm12083138plg.281.2022.07.19.11.10.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 11:10:08 -0700 (PDT)
Message-ID: <b6362f83-a71d-a816-85d8-126aadb6be38@acm.org>
Date:   Tue, 19 Jul 2022 11:10:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3] ufs: host: ufshcd-pltfrm: Hold reference returned by
 of_parse_phandle()
Content-Language: en-US
To:     Liang He <windhl@126.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org
References: <20220719071529.1081166-1-windhl@126.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220719071529.1081166-1-windhl@126.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/19/22 00:15, Liang He wrote:
> In ufshcd_populate_vreg(), we should hold the reference returned by
> of_parse_phandle() and then use it to call of_node_put() for refcount
> balance.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
