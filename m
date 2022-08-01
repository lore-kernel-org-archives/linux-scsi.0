Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12CDFC00144
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 07:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiHAHsr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 03:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiHAHsp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 03:48:45 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2112A2CCAB
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 00:48:44 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-10ee900cce0so822525fac.5
        for <linux-scsi@vger.kernel.org>; Mon, 01 Aug 2022 00:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=txgIaqgkqp1VgIksXCQEpfMy2daLHRq5YpFRe1NQI7g=;
        b=WGLsH6DDSOgZOxmMNvjBTXflXmWTvT9jzg/NaFsE7qqca0Q/BabewMAkM2FMU7ZQtc
         FwktHrHqXCCif4dSYOHa+z5eLJ+0uxcPhjHkE77vFHnb75ILE60xwtDweF83ZqF32/IJ
         Z9pXbv0Di7BJXV3aEwkRszL4DCqAj87/ZbfC8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=txgIaqgkqp1VgIksXCQEpfMy2daLHRq5YpFRe1NQI7g=;
        b=VwtC5u6Edf0ZsSzIBlvSjxmMaNjm4J5Yo/p+BRn0Fp1YjM+df4UGAT9zCx0SLjssk/
         603FWt+BwaoqpNqSA6OuLiRVYhgWCBGviUWLybXHAJTiIcxW+hYGqrlJosMfKekjXdue
         +GRP9G0Ffm64Lbiqav7xrJdWeMr2Tj256U6K+lSHuEMs9ZUmbIAD0jkrxhZzmP6ejSkQ
         ETQdK0uIOOcUFY9R6wS7AuNlkkqwtB9yS11i0RXkIaMvw9LYLHGzMvQAtj61n4FTiR+L
         NoknJ9pRHUHYjQcm4uuDCCs52WOGcp/Mfguc3/zg7ynj1stYZtQYBKKtlCikPi6MM15j
         WLZw==
X-Gm-Message-State: AJIora9M17MywpjIn3Uzj5UCDdnWor/HzKpkwxc4zb/QjVwE+kGSB8yo
        CZG8lrZFanXkXMwW4tk0SVmKiQ0BJ6BFVOHXPm3LWeQabKD8tw==
X-Google-Smtp-Source: AGRyM1tfiIeYBSvZE3PUexWsuo+ofv0lVwwhdNGRov71nzFgx6akChXIcJhfkG3Vv7zRrbvVmmrL8rV3q9AzQBnrtpc=
X-Received: by 2002:a05:6870:ec93:b0:10e:75ae:8177 with SMTP id
 eo19-20020a056870ec9300b0010e75ae8177mr6738739oab.234.1659340123241; Mon, 01
 Aug 2022 00:48:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
 <20220729131627.15019-7-sreekanth.reddy@broadcom.com> <14F6ACBA-27D4-4E0A-A788-5103145E7DD8@oracle.com>
In-Reply-To: <14F6ACBA-27D4-4E0A-A788-5103145E7DD8@oracle.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Mon, 1 Aug 2022 13:18:32 +0530
Message-ID: <CAK=zhgq6Pap4FHefhyCtuQnVKHK7tVZ_BMUWNQswvDwEzsBQ6w@mail.gmail.com>
Subject: Re: [PATCH 06/15] mpi3mr: Add helper functions to retrieve device objects
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000a2219705e5293a29"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000a2219705e5293a29
Content-Type: text/plain; charset="UTF-8"

On Sat, Jul 30, 2022 at 1:41 AM Himanshu Madhani
<himanshu.madhani@oracle.com> wrote:
>
>
>
> > On Jul 29, 2022, at 6:16 AM, Sreekanth Reddy <sreekanth.reddy@broadcom.com> wrote:
> >
> > Added below helper functions,
> > - Get the device's sas address by reading
> >  correspond device's Device page0,
> > - Get the expander object from expander list based
> >  on expander's handle,
> > - Get the target device object from target device list
> >  based on device's sas address,
> > - Get the expander device object from expander list
> >  based on expanders's sas address,
> > - Get hba port object from hba port table list
> >  based on port's port id
> >
> > Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> > ---
> > drivers/scsi/mpi3mr/mpi3mr.h           |  14 ++
> > drivers/scsi/mpi3mr/mpi3mr_os.c        |   3 +
> > drivers/scsi/mpi3mr/mpi3mr_transport.c | 280 +++++++++++++++++++++++++
> > 3 files changed, 297 insertions(+)
> >
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> > index 006bc5d..742caf5 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr.h
> > +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> > @@ -570,10 +570,12 @@ struct mpi3mr_enclosure_node {
> >  *
> >  * @sas_address: World wide unique SAS address
> >  * @dev_info: Device information bits
> > + * @hba_port: HBA port entry
> >  */
> > struct tgt_dev_sas_sata {
> >       u64 sas_address;
> >       u16 dev_info;
> > +     struct mpi3mr_hba_port *hba_port;
> > };
> >
> > /**
> > @@ -984,6 +986,10 @@ struct scmd_priv {
> >  * @cfg_page: Default memory for configuration pages
> >  * @cfg_page_dma: Configuration page DMA address
> >  * @cfg_page_sz: Default configuration page memory size
> > + * @sas_hba: SAS node for the controller
> > + * @sas_expander_list: SAS node list of expanders
> > + * @sas_node_lock: Lock to protect SAS node list
> > + * @hba_port_table_list: List of HBA Ports
> >  * @enclosure_list: List of Enclosure objects
> >  */
> > struct mpi3mr_ioc {
> > @@ -1162,6 +1168,10 @@ struct mpi3mr_ioc {
> >       dma_addr_t cfg_page_dma;
> >       u16 cfg_page_sz;
> >
> > +     struct mpi3mr_sas_node sas_hba;
> > +     struct list_head sas_expander_list;
> > +     spinlock_t sas_node_lock;
> > +     struct list_head hba_port_table_list;
> >       struct list_head enclosure_list;
> > };
> >
> > @@ -1317,4 +1327,8 @@ int mpi3mr_cfg_set_sas_io_unit_pg1(struct mpi3mr_ioc *mrioc,
> >       struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1, u16 pg_sz);
> > int mpi3mr_cfg_get_driver_pg1(struct mpi3mr_ioc *mrioc,
> >       struct mpi3_driver_page1 *driver_pg1, u16 pg_sz);
> > +
> > +u8 mpi3mr_is_expander_device(u16 device_info);
> > +struct mpi3mr_hba_port *mpi3mr_get_hba_port_by_id(struct mpi3mr_ioc *mrioc,
> > +     u8 port_id);
> > #endif /*MPI3MR_H_INCLUDED*/
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > index ca718cb..b75ce73 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > @@ -4692,11 +4692,14 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> >       spin_lock_init(&mrioc->tgtdev_lock);
> >       spin_lock_init(&mrioc->watchdog_lock);
> >       spin_lock_init(&mrioc->chain_buf_lock);
> > +     spin_lock_init(&mrioc->sas_node_lock);
> >
> >       INIT_LIST_HEAD(&mrioc->fwevt_list);
> >       INIT_LIST_HEAD(&mrioc->tgtdev_list);
> >       INIT_LIST_HEAD(&mrioc->delayed_rmhs_list);
> >       INIT_LIST_HEAD(&mrioc->delayed_evtack_cmds_list);
> > +     INIT_LIST_HEAD(&mrioc->sas_expander_list);
> > +     INIT_LIST_HEAD(&mrioc->hba_port_table_list);
> >       INIT_LIST_HEAD(&mrioc->enclosure_list);
> >
> >       mutex_init(&mrioc->reset_mutex);
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> > index 989bf63..fea3aae 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> > @@ -9,6 +9,237 @@
> >
> > #include "mpi3mr.h"
> >
> > +/**
> > + * __mpi3mr_expander_find_by_handle - expander search by handle
> > + * @mrioc: Adapter instance reference
> > + * @handle: Firmware device handle of the expander
> > + *
> > + * Context: The caller should acquire sas_node_lock
> > + *
> > + * This searches for expander device based on handle, then
> > + * returns the sas_node object.
> > + *
> > + * Return: Expander sas_node object reference or NULL
> > + */
> > +static struct mpi3mr_sas_node *__mpi3mr_expander_find_by_handle(struct mpi3mr_ioc
> > +     *mrioc, u16 handle)
> > +{
> > +     struct mpi3mr_sas_node *sas_expander, *r;
> > +
> > +     r = NULL;
> > +     list_for_each_entry(sas_expander, &mrioc->sas_expander_list, list) {
> > +             if (sas_expander->handle != handle)
> > +                     continue;
> > +             r = sas_expander;
> > +             goto out;
> > +     }
> > + out:
> > +     return r;
> > +}
> > +
> > +/**
> > + * mpi3mr_is_expander_device - if device is an expander
> > + * @device_info: Bitfield providing information about the device
> > + *
> > + * Return: 1 if the device is expander device, else 0.
> > + */
> > +u8 mpi3mr_is_expander_device(u16 device_info)
> > +{
> > +     if ((device_info & MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_MASK) ==
> > +          MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_EXPANDER)
> > +             return 1;
> > +     else
> > +             return 0;
> > +}
> > +
> > +/**
> > + * mpi3mr_get_sas_address - retrieve sas_address for handle
> > + * @mrioc: Adapter instance reference
> > + * @handle: Firmware device handle
> > + * @sas_address: Address to hold sas address
> > + *
> > + * This function issues device page0 read for a given device
> > + * handle and gets the SAS address and return it back
> > + *
> > + * Return: 0 for success, non-zero for failure
> > + */
> > +static int mpi3mr_get_sas_address(struct mpi3mr_ioc *mrioc, u16 handle,
> > +     u64 *sas_address)
> > +{
> > +     struct mpi3_device_page0 dev_pg0;
> > +     u16 ioc_status;
> > +     struct mpi3_device0_sas_sata_format *sasinf;
> > +
> > +     *sas_address = 0;
> > +
> > +     if ((mpi3mr_cfg_get_dev_pg0(mrioc, &ioc_status, &dev_pg0,
> > +         sizeof(dev_pg0), MPI3_DEVICE_PGAD_FORM_HANDLE,
> > +         handle))) {
> > +             ioc_err(mrioc, "%s: device page0 read failed\n", __func__);
> > +             return -ENXIO;
> > +     }
> > +
> > +     if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
> > +             ioc_err(mrioc, "device page read failed for handle(0x%04x), with ioc_status(0x%04x) failure at %s:%d/%s()!\n",
> > +                 handle, ioc_status, __FILE__, __LINE__, __func__);
> > +             return -ENXIO;
> > +     }
> > +
> > +     if (le16_to_cpu(dev_pg0.flags) &
> > +         MPI3_DEVICE0_FLAGS_CONTROLLER_DEV_HANDLE)
> > +             *sas_address = mrioc->sas_hba.sas_address;
> > +     else if (dev_pg0.device_form == MPI3_DEVICE_DEVFORM_SAS_SATA) {
> > +             sasinf = &dev_pg0.device_specific.sas_sata_format;
> > +             *sas_address = le64_to_cpu(sasinf->sas_address);
> > +     } else {
> > +             ioc_err(mrioc, "%s: device_form(%d) is not SAS_SATA\n",
> > +                 __func__, dev_pg0.device_form);
> > +             return -ENXIO;
> > +     }
> > +     return 0;
> > +}
> > +
> > +/**
> > + * __mpi3mr_get_tgtdev_by_addr - target device search
> > + * @mrioc: Adapter instance reference
> > + * @sas_address: SAS address of the device
> > + * @hba_port: HBA port entry
> > + *
> > + * This searches for target device from sas address and hba port
> > + * pointer then return mpi3mr_tgt_dev object.
> > + *
> > + * Return: Valid tget_dev or NULL
> > + */
> > +static struct mpi3mr_tgt_dev *__mpi3mr_get_tgtdev_by_addr(struct mpi3mr_ioc *mrioc,
> > +     u64 sas_address, struct mpi3mr_hba_port *hba_port)
> > +{
> > +     struct mpi3mr_tgt_dev *tgtdev;
> > +
> > +     assert_spin_locked(&mrioc->tgtdev_lock);
> > +
> > +     list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list)
> > +             if ((tgtdev->dev_type == MPI3_DEVICE_DEVFORM_SAS_SATA) &&
> > +                 (tgtdev->dev_spec.sas_sata_inf.sas_address == sas_address)
> > +                 && (tgtdev->dev_spec.sas_sata_inf.hba_port == hba_port))
> > +                     goto found_device;
> > +     return NULL;
> > +found_device:
> > +     mpi3mr_tgtdev_get(tgtdev);
> > +     return tgtdev;
> > +}
> > +
> > +/**
> > + * mpi3mr_get_tgtdev_by_addr - target device search
> > + * @mrioc: Adapter instance reference
> > + * @sas_address: SAS address of the device
> > + * @hba_port: HBA port entry
> > + *
> > + * This searches for target device from sas address and hba port
> > + * pointer then return mpi3mr_tgt_dev object.
> > + *
> > + * Context: This function will acquire tgtdev_lock and will
> > + * release before returning the mpi3mr_tgt_dev object.
> > + *
> > + * Return: Valid tget_dev or NULL
> > + */
> > +static struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_addr(struct mpi3mr_ioc *mrioc,
> > +     u64 sas_address, struct mpi3mr_hba_port *hba_port)
> > +{
> > +     struct mpi3mr_tgt_dev *tgtdev = NULL;
> > +     unsigned long flags;
> > +
> > +     if (!hba_port)
> > +             goto out;
> > +
> > +     spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> > +     tgtdev = __mpi3mr_get_tgtdev_by_addr(mrioc, sas_address, hba_port);
> > +     spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> > +
> > +out:
> > +     return tgtdev;
> > +}
> > +
> > +/**
> > + * mpi3mr_expander_find_by_sas_address - sas expander search
> > + * @mrioc: Adapter instance reference
> > + * @sas_address: SAS address of expander
> > + * @hba_port: HBA port entry
> > + *
> > + * Return: A valid SAS expander node or NULL.
> > + *
> > + */
> > +static struct mpi3mr_sas_node *mpi3mr_expander_find_by_sas_address(
> > +     struct mpi3mr_ioc *mrioc, u64 sas_address,
> > +     struct mpi3mr_hba_port *hba_port)
> > +{
> > +     struct mpi3mr_sas_node *sas_expander, *r = NULL;
> > +
> > +     if (!hba_port)
> > +             goto out;
> > +
> > +     list_for_each_entry(sas_expander, &mrioc->sas_expander_list, list) {
> > +             if ((sas_expander->sas_address != sas_address) ||
> > +                                      (sas_expander->hba_port != hba_port))
> > +                     continue;
> > +             r = sas_expander;
> > +             goto out;
> > +     }
> > +out:
> > +     return r;
> > +}
> > +
> > +/**
> > + * __mpi3mr_sas_node_find_by_sas_address - sas node search
> > + * @mrioc: Adapter instance reference
> > + * @sas_address: SAS address of expander or sas host
> > + * @hba_port: HBA port entry
> > + * Context: Caller should acquire mrioc->sas_node_lock.
> > + *
> > + * If the SAS address indicates the device is direct attached to
> > + * the controller (controller's SAS address) then the SAS node
> > + * associated with the controller is returned back else the SAS
> > + * address and hba port are used to identify the exact expander
> > + * and the associated sas_node object is returned. If there is
> > + * no match NULL is returned.
> > + *
> > + * Return: A valid SAS node or NULL.
> > + *
> > + */
> > +static struct mpi3mr_sas_node *__mpi3mr_sas_node_find_by_sas_address(
> > +     struct mpi3mr_ioc *mrioc, u64 sas_address,
> > +     struct mpi3mr_hba_port *hba_port)
> > +{
> > +
> Remove new line here
> > +     if (mrioc->sas_hba.sas_address == sas_address)
> > +             return &mrioc->sas_hba;
> > +     return mpi3mr_expander_find_by_sas_address(mrioc, sas_address,
> > +         hba_port);
> > +}
> > +
> > +/**
> > + * mpi3mr_parent_present - Is parent present for a phy
> > + * @mrioc: Adapter instance reference
> > + * @phy: SAS transport layer phy object
> > + *
> > + * Return: 0 if parent is present else non-zero
> > + */
> > +static int mpi3mr_parent_present(struct mpi3mr_ioc *mrioc, struct sas_phy *phy)
> > +{
> > +
> remove new line

Agree. Will remove it next version patch set.

> > +     unsigned long flags;
> > +     struct mpi3mr_hba_port *hba_port = phy->hostdata;
> > +
> > +     spin_lock_irqsave(&mrioc->sas_node_lock, flags);
> > +     if (__mpi3mr_sas_node_find_by_sas_address(mrioc,
> > +         phy->identify.sas_address,
> > +         hba_port) == NULL) {
> > +             spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> > +             return -1;
> > +     }
> > +     spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
> > +     return 0;
> > +}
> > +
> > /**
> >  * mpi3mr_convert_phy_link_rate -
> >  * @link_rate: link rate as defined in the MPI header
> > @@ -428,3 +659,52 @@ static int mpi3mr_add_expander_phy(struct mpi3mr_ioc *mrioc,
> >       mr_sas_phy->phy = phy;
> >       return 0;
> > }
> > +
> > +/**
> > + * mpi3mr_alloc_hba_port - alloc hba port object
> > + * @mrioc: Adapter instance reference
> > + * @port_id: Port number
> > + *
> > + * Alloc memory for hba port object.
> > + */
> > +static struct mpi3mr_hba_port *
> > +mpi3mr_alloc_hba_port(struct mpi3mr_ioc *mrioc, u16 port_id)
> > +{

> > +     struct mpi3mr_hba_port *hba_port;
> > +
> > +     hba_port = kzalloc(sizeof(struct mpi3mr_hba_port),
> > +         GFP_KERNEL);
> > +     if (!hba_port)
> > +             return NULL;
> > +     hba_port->port_id = port_id;
> > +     ioc_info(mrioc, "hba_port entry: %p, port: %d is added to hba_port list\n",
> > +         hba_port, hba_port->port_id);
> > +     list_add_tail(&hba_port->list, &mrioc->hba_port_table_list);
> > +     return hba_port;
> > +}
> > +
> > +/**
> > + * mpi3mr_get_hba_port_by_id - find hba port by id
> > + * @mrioc: Adapter instance reference
> > + * @port_id - Port ID to search
> > + *
> > + * Return: mpi3mr_hba_port reference for the matched port
> > + */
> > +
> > +struct mpi3mr_hba_port *mpi3mr_get_hba_port_by_id(struct mpi3mr_ioc *mrioc,
> > +     u8 port_id)
> > +{
> > +
> Ditto remove newline

Agree. Will remove it next version patch set.

> > +     struct mpi3mr_hba_port *port, *port_next;
> > +
> > +     list_for_each_entry_safe(port, port_next,
> > +         &mrioc->hba_port_table_list, list) {
> > +             if (port->port_id != port_id)
> > +                     continue;
> > +             if (port->flags & MPI3MR_HBA_PORT_FLAG_DIRTY)
> > +                     continue;
> > +             return port;
> > +     }
> > +
> > +     return NULL;
> > +}
> > --
> > 2.27.0
> >
>
> --
> Himanshu Madhani        Oracle Linux Engineering
>

--000000000000a2219705e5293a29
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMSS3PRUP9BQCAk3qX1s
+1ZDCx/6PN9LTM8g+IYVuBDsMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDgwMTA3NDg0M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBHwmwvAtE4nTbPKwBC3OOlUP77T7VhjqGa8wlQ
MQ8Bc+QSX//IX5dO/lzNp3vIoCiaKHgCD5vQ90cJhfGAI1TGRzvjFhrjNJWSEDNAbvss+zewcqT7
VYNg3qkGSs7WSafK7IscTVVyLxpK4wWndGKOwUUH6vOMnmfxHNVWExluRDtWrXLrzdv+QK8q5hnm
w9e8NSSqOx/gpgAKF0GbmJsg8CpbSuckncnFyAZAXFTwJa/OZT6gyg6z4pwnskmYuyZzgDi50Y6w
7Gzs5ORfF8RBBgzw2LueKon7v7MZG6fEkcO1V9SXZylioWzpCH6uo6r0NY4AxS5Hc0cx3YP4XWID
--000000000000a2219705e5293a29--
