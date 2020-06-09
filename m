Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCCA9C433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 00:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9D0420737
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 00:58:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="lUQuojRA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgFIA6l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 20:58:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27048 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731153AbgFIA6G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 20:58:06 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200609005803epoutp02ac18f1d88c38f4780fc29f12dc856069~Wujuo_Vse0374203742epoutp02C
        for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2020 00:58:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200609005803epoutp02ac18f1d88c38f4780fc29f12dc856069~Wujuo_Vse0374203742epoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591664283;
        bh=2ZdGa0WusYMlSIsrK40ujqb//hV2zjpeCw+1vy1+wno=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=lUQuojRAhoL4rHeXG7n0bTdESy12gPbTkpXQjPnrESB2AD6/5bvHQZlPj89yA8mui
         TdVv2+62cYbaj99d1BbhIuUB0N+pruN8a8D+fby8t1BLVrpd+n4VY5ORGN33247iNY
         jx9xxEigqC9M1s4DJxym+C8suWhafIz4h0Oj9Ncw=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p3.samsung.com
        (KnoxPortal) with ESMTP id
        20200609005803epcas1p3a8278aac6a6ccf493793ac8f95954dd0~WujuEQ_8W1119911199epcas1p3b;
        Tue,  9 Jun 2020 00:58:03 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [RFC PATCH 3/5] scsi: ufs: Introduce HPB module
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <SN6PR04MB46404CA953E4006BDCC61A65FC870@SN6PR04MB4640.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1431530910.81591664283090.JavaMail.epsvc@epcpadp2>
Date:   Tue, 09 Jun 2020 09:52:01 +0900
X-CMS-MailID: 20200609005201epcms2p82af5353727f989c2cf3da468f756bd2e
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882
References: <SN6PR04MB46404CA953E4006BDCC61A65FC870@SN6PR04MB4640.namprd04.prod.outlook.com>
        <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
        <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
        <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
        <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
        <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p8>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Why not just allow for max-active-regions per the device's configuration?
> The platform vendor can provision it per its need.
The max-active-region is configured as device config. The module parameter =
which you mentioned is just minimum value of the memory pool.

> > +
> > +       total_srgn_cnt =3D hpb->srgns_per_lu;
> > +       for (rgn_idx =3D 0, srgn_cnt =3D 0; rgn_idx < hpb->rgns_per_lu;
> > +            rgn_idx++, total_srgn_cnt -=3D srgn_cnt) {
> Maybe simplify and improve readability by moving the srgn_cnt into the fo=
r clause:
> =09int srgn_cnt =3D hpb->srgns_per_rgn;
OK, I will apply this for patch v2.

> > +
> > +static void ufshpb_destroy_region_tbl(struct ufshpb_lu *hpb)
> > +{
> > +       int rgn_idx;
> > +
> > +       for (rgn_idx =3D 0; rgn_idx < hpb->rgns_per_lu; rgn_idx++) {
> > +               struct ufshpb_region *rgn;
> > +
> > +               rgn =3D hpb->rgn_tbl + rgn_idx;
> > +               if (rgn->rgn_state !=3D HPB_RGN_INACTIVE) {
> > +                       rgn->rgn_state =3D HPB_RGN_INACTIVE;
> > +
> > +                       ufshpb_destroy_subregion_tbl(hpb, rgn);
> > +               }
> > +
> > +               kvfree(rgn->srgn_tbl);
> This looks like it belongs to ufshpb_destroy_subregion_tbl?
Yes, it will be changed.

> How about calling ufshpb_issue_hpb_reset_query right after ufshpb_get_dev=
_info?
> This way waiting for the device to complete its reset can be done while s=
csi is scanning the luns?
I will change the call path as follows:
- ufshpb_probe_async
  - ufshpb_get_dev_info
 =EF=83=A0 - ufshpb_issue_hpb_reset_query 1/2 (query part)
  - ufshpb_scan_hpb_lu
 =EF=83=A0 - ufshpb_issue_hpb_reset_query 2/2 (wait part)

> > +
> > +static void ufshpb_reset(struct ufs_hba *hba)
> > +static void ufshpb_reset_host(struct ufs_hba *hba)
> > +static void ufshpb_suspend(struct ufs_hba *hba)
> > +static void ufshpb_resume(struct ufs_hba *hba)
> The above 4 functions essentially runs the same code but set a different =
state.
> Maybe call a helper?
OK, I will.

> > +static int ufshpb_create_sysfs(struct ufs_hba *hba, struct ufshpb_lu *=
hpb)
> Why separate from ufs-sysfs?
> Also you might want to introduce all the stats not as part of the functio=
nal patch.
The HPB feature is implemented as a device. So, We added the hpb-sysfs sepa=
rated from ufs-sysfs.

> > +
> > +static int ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf,
> > +                              struct ufshpb_dev_info *hpb_dev_info)
> > +{
> > +       int hpb_device_max_active_rgns =3D 0;
> > +       int hpb_num_lu;
> > +
> > +       hpb_dev_info->max_num_lun =3D
> > +               geo_buf[GEOMETRY_DESC_PARAM_MAX_NUM_LUN] =3D=3D 0x00 ? =
8 :
> > 32;
> You already have this in hba->dev_info.max_lu_supported
> > +
> > +       hpb_num_lu =3D geo_buf[GEOMETRY_DESC_HPB_NUMBER_LU];
> You should capture hpb_dev_info->max_num_lun =3D hpb_num_lu
You are right. And hpb_dev_info->max_num_lun will be deleted.

> > +
> > +       ret =3D ufshpb_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, SELECTO=
R,
> > +                            desc_buf, hba->desc_size.dev_desc);
> What with this SELECTOR stuff?
> Why not the default 0?
Right, SELECTOR should be 0. I will fix it.=20

> What about the other hpb fields in the device descriptor:
> DEVICE_DESC_PARAM_HPB_VER and DEVICE_DESC_PARAM_HPB_CONTROL ?
I will add codes that checks these fields on initialization.

> > +unsigned int ufshpb_host_map_kbytes =3D 1 * 1024;
> > +module_param(ufshpb_host_map_kbytes, uint, 0644);
> > +MODULE_PARM_DESC(ufshpb_host_map_kbytes,
> > +        "ufshpb host mapping memory kilo-bytes for ufshpb memory-pool"=
);
> You should introduce this module parameter in the patch that uses it.
OK, could you recommend good location of introducing message? At the patch =
letter or in the codes?

Thanks,
Daejun

