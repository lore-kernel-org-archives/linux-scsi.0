Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270EFC38A2D
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 17:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbiJXRK2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Oct 2022 13:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234503AbiJXRJq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2022 13:09:46 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3FA58B5A
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2022 08:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1666626313; x=1698162313;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5jm8Z/STsh6ZtSXhL0p68t3mhS6r4bb6F/JkO48Wf2I=;
  b=teSXgpU/I2pdSv46Ib4bXDLdnqZ06aTqAlwmM6QGFuz+d+/YPM6J1RJ6
   T5WF7ZfRUXgGzomvYRK0UHDyhEP/zBm8wJ+Kz7kvrVBXWgLnW3Ac0Hakr
   P1v89BtINqz21Lne0pO65pCIFjAK0utqZXkP6Qg5F+WklhQGQhGhHw6gF
   0=;
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 24 Oct 2022 08:43:41 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg04-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 08:43:41 -0700
Received: from asutoshd-linux1.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 24 Oct 2022 08:43:40 -0700
Date:   Mon, 24 Oct 2022 08:43:40 -0700
From:   Asutosh Das <quic_asutoshd@quicinc.com>
To:     <peter.wang@mediatek.com>
CC:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: print more evt history
Message-ID: <20221024154340.GC18511@asutoshd-linux1.qualcomm.com>
References: <20221024120602.30019-1-peter.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Disposition: inline
In-Reply-To: <20221024120602.30019-1-peter.wang@mediatek.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 24 2022 at 06:11 -0700, peter.wang@mediatek.com wrote:
>From: Peter Wang <peter.wang@mediatek.com>
>
>Some error event is missing in ufshcd_print_evt_hist.
>Add print for this error event.
>
>Signed-off-by: Peter Wang <peter.wang@mediatek.com>
>---
> drivers/ufs/core/ufshcd.c | 3 +++
> 1 file changed, 3 insertions(+)
>
Reviewed-by: Asutosh Das <quic_asutoshd@quicinc.com>

>2.18.0
>
