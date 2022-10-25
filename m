Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 298AEC04A95
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Oct 2022 13:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbiJYNgw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Oct 2022 09:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbiJYNgr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Oct 2022 09:36:47 -0400
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A254191D60;
        Tue, 25 Oct 2022 06:36:46 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id q1so11467444pgl.11;
        Tue, 25 Oct 2022 06:36:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RwMLX94p14UQlTFG0MXaXfw8tgk5NXWCFsR6sl1nd1s=;
        b=uYZX7snqHAssyqYnEpV2PMWej6dCRw0Y9YyuwhknlQDyVPAe3tguF33RqHCdPEAfap
         LqpYL+/fmGCiYcqL8/VFy8fJ+tj5fr2qcomWYQ/gVuCG0EUEodxSpJz3Mm4rvmPZ1QAU
         W7a6wqvRy67qk+usNFMpQhO1iTzlhdGz2MwKWmmHaJ1lu03MmWSoqaLFYed9yTRG4oTn
         Ob2AHEr8Vf+iO0hbLQSDWUqcHVJ9WigCA3rBTQGon+s7y+G45YddYgXJZVdStIFJTDuO
         WmtAXRNZAW8zh3dBm9u68BPwXqmcdXXHBGFmMjO/nzgJOe5cQrbWzKuHWyImPq4izM/Z
         nBGw==
X-Gm-Message-State: ACrzQf3U9vpwxqiZW4rYYvVdXvw3qp56zEH+VYHe63h02LuGQyF7Tauq
        fbLhA2q0LAV7CzZexC4It30=
X-Google-Smtp-Source: AMsMyM74SzJ9JZbZNZo3FynvYj2/T+Tn5bfZjCaWB8VMBFBglLl7REZECXeluuFdBZVVKSXE3hpGQw==
X-Received: by 2002:a63:1917:0:b0:43c:1471:52b7 with SMTP id z23-20020a631917000000b0043c147152b7mr32406179pgl.522.1666705005893;
        Tue, 25 Oct 2022 06:36:45 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id i6-20020a17090332c600b0017f57787a4asm1235163plr.229.2022.10.25.06.36.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 06:36:44 -0700 (PDT)
Message-ID: <d2d9f936-72d7-1d7f-f6e9-44aba745cac6@acm.org>
Date:   Tue, 25 Oct 2022 06:36:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v4 2/3] scsi: ufs: core: Cleanup ufshcd_slave_alloc()
Content-Language: en-US
To:     Bean Huo <beanhuo@iokpp.de>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org,
        daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221022213650.626766-1-beanhuo@iokpp.de>
 <20221022213650.626766-3-beanhuo@iokpp.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221022213650.626766-3-beanhuo@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/22/22 14:36, Bean Huo wrote:
> Combine ufshcd_get_lu_power_on_wp_status() and ufshcd_set_queue_depth()
> into one single ufshcd_lu_init(), so that we only need to read the LUN
> descriptor once.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

