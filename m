Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B188EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 02:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbiDGCgB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 22:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbiDGCf4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 22:35:56 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD3C1FCD25
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 19:33:57 -0700 (PDT)
X-UUID: 95f5044f7799449ea4ea0a2217b2bcab-20220407
X-UUID: 95f5044f7799449ea4ea0a2217b2bcab-20220407
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2074563841; Thu, 07 Apr 2022 10:33:53 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 7 Apr 2022 10:33:51 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 7 Apr 2022 10:33:51 +0800
Message-ID: <1fa79205b7fdd6c3061dbf93d44a6f8dd4adc6d5.camel@mediatek.com>
Subject: Re: [PATCH 11/29] scsi: ufs: Remove unused constants and code
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Date:   Thu, 7 Apr 2022 10:33:51 +0800
In-Reply-To: <DM6PR04MB657598992B8F67FD787BFAB8FCE49@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
         <20220331223424.1054715-12-bvanassche@acm.org>
         <DM6PR04MB6575F371F794F5AA28FCCB33FCE39@DM6PR04MB6575.namprd04.prod.outlook.com>
         <4d6c2e51-b8d7-6f2b-bcd6-a26d60a21fce@acm.org>
         <DM6PR04MB657598992B8F67FD787BFAB8FCE49@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart, Avri,

On Tue, 2022-04-05 at 06:55 +0000, Avri Altman wrote:
> > 
> > On 4/1/22 23:59, Avri Altman wrote:
> > > > 
> > > > Commit 5b44a07b6bb2 ("scsi: ufs: Remove pre-defined initial
> > > > voltage
> > > > values of device power") removed the code that uses the
> > 
> > UFS_VREG_VCC*
> > > > constants and also the code that sets the min_uV and max_uV
> > > > member
> > > > variables. Hence also remove these constants and that member
> > > > variable.
> > > > 
> > > > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > > 
> > > Looks fine to me, but better get an ack from Stanley, because he
> > > specifically wrote in his commit log:
> > > "...
> > > Note that we keep struct ufs_vreg unchanged. This allows vendors
> > > to
> > >      configure proper min_uV and max_uV of any regulators to make
> > >      regulator_set_voltage() works during regulator toggling flow
> > > in the
> > >      future. Without specific vendor configurations, min_uV and
> > > max_uV will
> > 
> > be
> > >      NULL by default and UFS core driver will enable or disable
> > > the regulator
> > >      only without adjusting its voltage.
> > > ..."
> > 
> > (+Stanley)
> > 
> > Hi Stanley,
> > 
> > Can you take a look at this patch?
> 
> If Stanley won't comment by your v2 - please add my RB.
> 
> Thanks,
> Avri
> 

Fine to me: )

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>


