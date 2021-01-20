Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E1FEC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 18:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E13822473
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 18:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392022AbhATSiI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 13:38:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:50480 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404714AbhATSgb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Jan 2021 13:36:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611167737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+jXt5yJ5Y8QNHRhuh8IZu2a1gqzxuHWC03/n2HN79UE=;
        b=XPpZ9NKDavEFgDRV5r9AnGyrucqQbMEKH0mBiCHbpZ0MWCh/s0hQ3da+m8hRE8qqMLPK2G
        xrTcqpprj6huiAVI40y8lx2JC74cJnkO5wwH2dpUQd8W38g5z53vEEouxjSjTw4f+WwfGj
        CYOL1splMO2dmo9mA5AkJ+OIMa1KbEg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 228C5AC63;
        Wed, 20 Jan 2021 18:35:37 +0000 (UTC)
Message-ID: <16d6fb58b756b12ed082492fc3f0096a58f377da.camel@suse.com>
Subject: Re: [PATCH V3 15/25] smartpqi: fix host qdepth limit
From:   Martin Wilck <mwilck@suse.com>
To:     Donald Buczek <buczek@molgen.mpg.de>,
        John Garry <john.garry@huawei.com>, Don.Brace@microchip.com,
        pmenzel@molgen.mpg.de, Kevin.Barnett@microchip.com,
        Scott.Teel@microchip.com, Justin.Lindley@microchip.com,
        Scott.Benesh@microchip.com, Gerry.Morong@microchip.com,
        Mahesh.Rajashekhara@microchip.com, hch@infradead.org,
        joseph.szczypek@hpe.com, POSWALD@suse.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Ming Lei <ming.lei@redhat.com>
Cc:     linux-scsi@vger.kernel.org, it+linux-scsi@molgen.mpg.de,
        gregkh@linuxfoundation.org
Date:   Wed, 20 Jan 2021 19:35:35 +0100
In-Reply-To: <f97756ca-84fc-9960-80fb-14e65986c880@molgen.mpg.de>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763254769.26927.9249430312259308888.stgit@brunhilda>
         <ddd8bca4-2ae7-a2dc-cca6-0a2ff85a7d35@molgen.mpg.de>
         <SN6PR11MB28487527276CEBC75D36A732E1C60@SN6PR11MB2848.namprd11.prod.outlook.com>
         <85c6e1705c55fb930ac13bc939279f0d1faa526f.camel@suse.com>
         <SN6PR11MB2848C1195C65F87C910E979BE1A70@SN6PR11MB2848.namprd11.prod.outlook.com>
         <b3e4e597-779b-7c1e-0d3c-07bc3dab1bb5@huawei.com>
         <4555695d649afada5d4358485f0a146aa0848f65.camel@suse.com>
         <f97756ca-84fc-9960-80fb-14e65986c880@molgen.mpg.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-01-20 at 17:42 +0100, Donald Buczek wrote:
> 
> I'm not into this and can't comment on that. But if you need me to
> test any patch for verification, I'll certainly can do that.

I'll send an *experimental* patch.

Thanks
Martin


