Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE05C3DA78
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 09:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235791AbjAQJ44 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 04:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235462AbjAQJ4v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 04:56:51 -0500
Received: from air.basealt.ru (air.basealt.ru [194.107.17.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11581DB80
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2023 01:56:50 -0800 (PST)
Received: by air.basealt.ru (Postfix, from userid 490)
        id DB1E62F2022E; Tue, 17 Jan 2023 09:56:47 +0000 (UTC)
Received: from localhost (broadband-188-32-10-232.ip.moscow.rt.ru [188.32.10.232])
        by air.basealt.ru (Postfix) with ESMTPSA id 76CA72F2022C;
        Tue, 17 Jan 2023 09:56:46 +0000 (UTC)
Date:   Tue, 17 Jan 2023 12:56:45 +0300
From:   "Alexey V. Vissarionov" <gremlin@altlinux.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Alexey V. Vissarionov" <gremlin@altlinux.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] scsi: hpsa: fix allocation size for scsi_host_alloc()
Message-ID: <20230117095644.GA12547@altlinux.org>
References: <20230116133140.GB8107@altlinux.org>
 <39006233-ff6f-82ad-b772-e00e789375a5@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <39006233-ff6f-82ad-b772-e00e789375a5@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023-01-16 14:41:08 -0800, Bart Van Assche wrote:

 >> Fixes: b705690d8d16f708 ("[SCSI] hpsa: combine hpsa_scsi_detect
 >> and hpsa_register_scsi")
 > That seems incorrect to me. Shouldn't the Fixes tag be changed
 > into the following?
 > Fixes: edd163687ea5 ("[SCSI] hpsa: add driver for HP Smart Array
 > controllers.")

% git blame -L 5853,+1 -- drivers/scsi/hpsa.c
b705690d8d16f7081 (Stephen M. Cameron 2012-01-19 14:00:53 -0600 5853)
	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(h));

Is anything wrong here?


-- 
Alexey V. Vissarionov
gremlin נעי altlinux פ‏כ org; +vii-cmiii-ccxxix-lxxix-xlii
GPG: 0D92F19E1C0DC36E27F61A29CD17E2B43D879005 @ hkp://keys.gnupg.net
