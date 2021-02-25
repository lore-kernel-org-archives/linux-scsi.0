Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD31AC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 02:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8886864ED1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 02:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbhBYCnf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 21:43:35 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:38819 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235145AbhBYCne (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 21:43:34 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210225024250epoutp04d8baf573677c88cafcfbfb30d9821f55~m3WuVtEHE0714307143epoutp04N
        for <linux-scsi@vger.kernel.org>; Thu, 25 Feb 2021 02:42:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210225024250epoutp04d8baf573677c88cafcfbfb30d9821f55~m3WuVtEHE0714307143epoutp04N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614220970;
        bh=e3AFiROqVU3nps63r1WGPGZrx4KQX0tP1d5/Mjlhtv4=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=gomI+6kE5sXoZ5nvYy7h/1gP2Du2oVahVSVhu4l6gQcV4uU2Xahgxov98WxduZrG7
         IIrL38fQ9ZmUyszMC1iZwxg0jsNqw+eIm35RSnEVwaIvqek87hiEgwDuE2ec1RgxDW
         tMhqsP/iYdelN4aJ5lC6m00NG50Gt9KMI8qTDtyE=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210225024249epcas2p2c3de1f0a65f69abff59fb9a9ee7c0a3d~m3WtafWIE1343213432epcas2p2J;
        Thu, 25 Feb 2021 02:42:49 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DmHBv3TGFz4x9Q3; Thu, 25 Feb
        2021 02:42:47 +0000 (GMT)
X-AuditID: b6c32a46-1d9ff7000000dbf8-05-60370ea77ba9
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        76.A2.56312.7AE07306; Thu, 25 Feb 2021 11:42:47 +0900 (KST)
Mime-Version: 1.0
Subject: RE: RE: RE: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <DM6PR04MB65754EE70E1E61C46309AF9DFC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210225024246epcms2p76340994168c3985fcb55106ba54463ef@epcms2p7>
Date:   Thu, 25 Feb 2021 11:42:46 +0900
X-CMS-MailID: 20210225024246epcms2p76340994168c3985fcb55106ba54463ef
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA12TfUxbVRjGc+4tvZdKyaXAODA3ySXiQIGWrOxMQSVbyFVkIVEwzizlBi6F
        WNraW1RM5qqwgSAf+1CwMgZljMnAjo9CByKEbgzCEDecCBvYidtkhq2OP+RjNFIKbvG/33nO
        e87zvOeDxCWzwiAyW63ndGpWRQtFgk5bmDyi0XtXmrTCGIjsNZ1C1HtkiEBzS9eFyHbjPoG+
        cizh6KH5jAeaGwhDTfa3UX69WYiqRw0YKi23CNHszQUCmX7txFC5s1CAxrurhahkwipEjZed
        GLrRIUINlkmAPq9sFiBTXY/gVX9m/OdEZrysFGMuGKcJpsLUD5i+k80EUzDcJ2D+vj0lYMo6
        mgCz0LadKewvwZJF+1WxWRybwemCOXW6JiNbrYyjE99U7FHIY6SyCNlutIsOVrM5XBy9943k
        iIRs1VqHdPAHrCp3TUpmeZ6OejlWp8nVc8FZGl4fR3PaDJVWJtNG8mwOn6tWRqZrcl6USaXR
        8rXKNFVWU18VoT0h+mi6ZQIzgAaiGHiSkNoJnfdGsGIgIiWUFUBr61mPYkCSYsoHrlp9XTW+
        1B5Ye+20h4slFA3NV42EW4+EU7eagYuF1Auwcug3wrWPH3VWAK8uXxO6Bji1jMGhWQdwu4lh
        VeFtgZu3wq5GC3CZeVIHYNHMO255B1w8U4q72R9OnpsnNvnB4KmNbfzg4ZnRjRofaF/q2dAD
        4WCPA3PzIWi5uQxcGSD1BYC2C1Me7oko+EtR63oGMZUEv3WeXmcB9Syc++HYRs1eeKXg0roB
        Tj0Du+arcVdOnAqD5u4oF0IqBF6cEmx2ZWhdIf7POOUNi2yr/+nWmj82ooXC75bMWAUIMT4+
        aeMTXsbHXrUAbwJbOC2fo+T4aG30k5fbBtZfe3iCFZyYd0QOAIwEAwCSOO0nbnfK0yTiDDbv
        Y06nUehyVRw/AORrXR7Fg/zTNWvfRa1XyOTRMTHS3XIkj4lGdICYl9oVEkrJ6rn3OE7L6TbX
        YaRnkAF7a6WGSL60Kjl6cIzKJj47NLLSMjFcuC9/Acnqah6NpIadSyqQfN2qT6kLTL5F/tX3
        z4FH5+O9PAd9q8ZTFue7e7/3spps36gdEUcM7560zw33/0iewohti1cUi2o/dU+I/EtlVX29
        fSTgNWem6d5gYMDv4V21+q1Td/bnye6UmRMrc2fv/vnUtt6S85PvpyoP17fsPOY181xAvHOs
        /v4rjWSxoyNRa9nXcDHl+odM+fRPbYlbSkouWzx0oz7euoQHsbZM0Y72fAPotmsjXgplB0KT
        fO7mPd3ySQjs0nfmB7HaMsXDnNe3y4fSC03OhrHsoYzU50eLLfGZdE97e9Snxw/SAj6LlYXj
        Op79F3Z4SfZ2BAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210222092907epcms2p307f3c4116349ebde6eed05c767287449
References: <DM6PR04MB65754EE70E1E61C46309AF9DFC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
        <DM6PR04MB6575DA862FD50130DAF1E573FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76@epcms2p1>
        <20210223235458epcms2p666e7cca021e09c715ca3b11ada39ebeb@epcms2p6>
        <DM6PR04MB657573102C577230A3079DBBFC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p7>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > > > @@ -2656,7 +2656,12 @@ static int ufshcd_queuecommand(struct
> > > Scsi_Host
> > > > > *host, struct scsi_cmnd *cmd)
> > > > >
> > > > >         lrbp->req_abort_skip = false;
> > > > >
> > > > > -       ufshpb_prep(hba, lrbp);
> > > > > +       err = ufshpb_prep(hba, lrbp);
> > > > > +       if (err == -EAGAIN) {
> > > > > +               lrbp->cmd = NULL;
> > > > > +               ufshcd_release(hba);
> > > > > +               goto out;
> > > > > +       }
> > > > Did I miss-read it, or are you bailing out of wb failed e.g. because no tag is
> > > available?
> > > > Why not continue with read10?
> > >
> > > We try to sending HPB read several times within the requeue_timeout_ms.
> > > Because it strategy has more benefit for overall performance in this
> > > situation that many requests are queueing.
> > This extra logic, IMO, should be optional.  Default none.
> > And yes, in this case requeue_timeout should be a parameter for each OEM to
> > scale.
> And either way, hpb internal flows should not cause dumping the command.
> Worse case - continue as READ10

However, this can improve the overall performance and should be used
carefully. The problem can be solved by setting the default timeout
ms to 0. And OEM can change it.

Thanks,
Daejun
