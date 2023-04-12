Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB93C77B6E
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 20:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjDLUmX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjDLUmX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2023 16:42:23 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417BD59E0
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 13:42:21 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id f2so4386034pjs.3
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 13:42:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681332141; x=1683924141;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sxMMw+RE/B1wpsaBqg6Sk8Lopx8r26vVcP9HkKkCpYI=;
        b=gcCNHUMRrBzdqg2RBUiyLYrB54MP4NDvNKngVQ4uRD0cfAXuvndtnPu1HK4xBv1Dhd
         QHtX2i/S9AjN6qnXjkqj0vE3CY48Qbn3rz2ozChWK2/RaxLct9REzvQi7D2uAvEkuf5T
         R7xcc0rdFV2ZgD2WZ2Sxzd6LU1mEOG8ErOYNUpXQEn9qxIHwdELwaAad4sje5J0vRbRw
         AOyqEgFjOLChSRK//tRC/wBGPdSORAH9MPRSFBHzILhrna0uf9nwJtLBro5Qvq42JQRj
         Q5C3o7+Z1CpyfoCQzi/tnSIKW8MdvkWn5SZ4ofuML0SL2jLcvFrrJRjqc73pvZk2OEPo
         OjDg==
X-Gm-Message-State: AAQBX9eC7PZEk5gMSxMiVuY0V5qPSSDPKrE2HfHBuiCusqfSCxZeKYlB
        F82ZDLcy3JtnFQgWcNlrjYM=
X-Google-Smtp-Source: AKy350YFDffPQwEu/mcj76pV9P14oAjMXKjV/x6y1y6HQ2e/ttaQlT1b9wRqnZm9OmOs356NfODWQQ==
X-Received: by 2002:a05:6a20:659c:b0:d9:b820:10a4 with SMTP id p28-20020a056a20659c00b000d9b82010a4mr17799727pzh.8.1681332140602;
        Wed, 12 Apr 2023 13:42:20 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:d89d:35dd:5938:1993? ([2620:15c:211:201:d89d:35dd:5938:1993])
        by smtp.gmail.com with ESMTPSA id t2-20020a634602000000b0050f93a3586fsm19971pga.37.2023.04.12.13.42.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 13:42:20 -0700 (PDT)
Message-ID: <89fcd6ac-5983-d80f-c052-ef70fb5af0cb@acm.org>
Date:   Wed, 12 Apr 2023 13:42:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 2/3] scsi: ufs: Simplify ufshcd_wl_shutdown()
Content-Language: en-US
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>,
        Tomas Henzl <thenzl@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
References: <20230412204029.3222134-1-bvanassche@acm.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230412204029.3222134-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/23 13:40, Bart Van Assche wrote:
 > [ ... ]

Please ignore this patch.

Bart.
