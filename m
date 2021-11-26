Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0717C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 16:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354607AbhKZQll (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 11:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239282AbhKZQjk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 11:39:40 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C71C06175C
        for <linux-scsi@vger.kernel.org>; Fri, 26 Nov 2021 08:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1637943691;
        bh=Y9HSFTcCrFtnReYTTXOKf3J5RzZ2hRTZup2WHrnjaWc=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=fIKTDqXenZz/2WU/SrUQTKwBR/AJMNQksSSXgLCMsFD+y9e+NdgXT1wkQmMh7wQbL
         guO2Jv7Vsm3cPMEZgpDdpAbyN/KgHSqFubga/0Dr6/PirtN5o6F9FkhHTcowDrC+Mf
         K4Y/KyXLZWMkDs2uA4uIXq6tc5CyvePfnc4bl01w=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 3813F12808B7;
        Fri, 26 Nov 2021 11:21:31 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kncOCKoMM_L2; Fri, 26 Nov 2021 11:21:31 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1637943691;
        bh=Y9HSFTcCrFtnReYTTXOKf3J5RzZ2hRTZup2WHrnjaWc=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=fIKTDqXenZz/2WU/SrUQTKwBR/AJMNQksSSXgLCMsFD+y9e+NdgXT1wkQmMh7wQbL
         guO2Jv7Vsm3cPMEZgpDdpAbyN/KgHSqFubga/0Dr6/PirtN5o6F9FkhHTcowDrC+Mf
         K4Y/KyXLZWMkDs2uA4uIXq6tc5CyvePfnc4bl01w=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 8D3D812807B3;
        Fri, 26 Nov 2021 11:21:30 -0500 (EST)
Message-ID: <75aa75adfd5f17d256c0a242a31c04032ecafe3f.camel@HansenPartnership.com>
Subject: Re: [PATCH V2] scsi:spraid: initial commit of Ramaxel spraid driver
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Yanling Song <songyl@ramaxel.com>, martin.petersen@oracle.com,
        bvanassche@acm.org
Cc:     linux-scsi@vger.kernel.org, yujiang@ramaxel.com
Date:   Fri, 26 Nov 2021 11:21:29 -0500
In-Reply-To: <20211126073310.87683-1-songyl@ramaxel.com>
References: <20211126073310.87683-1-songyl@ramaxel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-11-26 at 15:33 +0800, Yanling Song wrote:
> This initial commit contains Ramaxel's spraid module.
> 
> Signed-off-by: Yanling Song <songyl@ramaxel.com>

Please stop.  Something in your organization has sent this same email
to the list over 20 times now.  The headers seem to confirm it's
something at your end not vger:

Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353875AbhKZOv4 (ORCPT
        <rfc822;James.Bottomley@hansenpartnership.com>);
        Fri, 26 Nov 2021 09:51:56 -0500
Received: from email.unionmem.com ([221.4.138.186]:60920 "EHLO
 VLXDG1SPAM1.ramaxel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with
 ESMTP id S1353445AbhKZOt4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>); Fri,
 26 Nov 2021 09:49:56 -0500
Received: from VLXDG1SPAM1.ramaxel.com (localhost [127.0.0.2] (may be
 forged)) by VLXDG1SPAM1.ramaxel.com with ESMTP id 1AQ7rqwC023264 for
 <linux-scsi@vger.kernel.org>; Fri, 26 Nov 2021 15:53:52 +0800 (GMT-8)
 (envelope-from songyl@ramaxel.com)
Received: from V12DG1MBS01.ramaxel.local (v12dg1mbs01.ramaxel.local
 [172.26.18.31]) by VLXDG1SPAM1.ramaxel.com with ESMTPS id 1AQ7XF7m009870
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL); Fri, 26
 Nov 2021 15:33:15 +0800 (GMT-8) (envelope-from songyl@ramaxel.com)
Received: from localhost.localdomain (10.64.9.47) by
 V12DG1MBS01.ramaxel.local (172.26.18.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Fri, 26 Nov 2021 15:33:15 +0800
From:   Yanling Song <songyl@ramaxel.com>
To:     <martin.petersen@oracle.com>, <bvanassche@acm.org>
CC:     <linux-scsi@vger.kernel.org>, <songyl@ramaxel.com>,
        <yujiang@ramaxel.com>
Subject: [PATCH V2] scsi:spraid: initial commit of Ramaxel spraid driver
Date:   Fri, 26 Nov 2021 15:33:10 +0800

I'd guess whatever the problem is, it's at your outbound spam filter:
VLXDG1SPAM1.ramaxel.com

We can fix it at our end by blocking email from the ramaxel.com domain
but that would be a bit drastic ...

James


