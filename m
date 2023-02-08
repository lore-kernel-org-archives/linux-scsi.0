Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1439C64EC7
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Feb 2023 11:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbjBHLT5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Feb 2023 06:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjBHLTZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2023 06:19:25 -0500
X-Greylist: delayed 1222 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 08 Feb 2023 03:18:38 PST
Received: from barokahperkasagroup.com (barokahperkasagroup.com [139.99.19.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6517849018
        for <linux-scsi@vger.kernel.org>; Wed,  8 Feb 2023 03:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=barokahperkasagroup.com; s=default; h=Content-Transfer-Encoding:
        Content-Type:Subject:From:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rLFGE2Ap4KmDdDml+dJXv4c1x1DTqGgCpDhkcc7E0s0=; b=gZsmX83Q4t91jmTJehI041RnrQ
        +R8D10FCGcpn/wMQE4BZPweBXpT3/1fqOJ7HyRKS1HtZzWmhZe2dOT0+9L8+/ei9z2Q1tUiMbE1B5
        Za7yEteVmVmEKWgAyKQ42ty5ttnUYClDQj8jyOwJ/eCc5nOwykT9idjcHLgxPiFu7BltvWjEpIyi5
        ES3D3EtIGWoo1yzB5AXzwbJj+pTOez5ndM3CXS+6JF0f/Wt2azq/XaQFL8KBaBVNxuVDxkob7iJBz
        rkxWTQafGuk2oNXLEo7tVL49nPeFwJnF1QNJ6qtJ3g8dvfl3PVRmxwuSeLf1cTsIm1Pj6rADFReAE
        RTaNVjqw==;
Received: from [43.230.195.202] (port=39982 helo=imap.barokahperkasagroup.com)
        by hosting.barokahperkasagroup.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <fadlyhamzairi@barokahperkasagroup.com>)
        id 1pPi9T-0004mg-D1
        for linux-scsi@vger.kernel.org;
        Wed, 08 Feb 2023 17:58:14 +0700
Message-ID: <4g2ru6r8-62rc-nz5q-7vu8-qasevv0mn8t7@barokahperkasagroup.com>
Date:   Wed, 8 Feb 2023 13:57:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.6
Content-Language: en-us
To:     "linux scsi" <linux-scsi@vger.kernel.org>
From:   "Arpit Patel" <fadlyhamzairi@barokahperkasagroup.com>
Subject: hi linux scsi
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hosting.barokahperkasagroup.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - barokahperkasagroup.com
X-Get-Message-Sender-Via: hosting.barokahperkasagroup.com: authenticated_id: fadlyhamzairi@barokahperkasagroup.com
X-Authenticated-Sender: hosting.barokahperkasagroup.com: fadlyhamzairi@barokahperkasagroup.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-From-Rewrite: rewritten was: [arpit_patel@barokahperkasagroup.com], actual sender does not match
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Linux  https://bit.ly/3I2rIZp  Arpit
