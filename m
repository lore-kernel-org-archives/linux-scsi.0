Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED789CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 21:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB10D21872
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 21:34:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HPX4V5eE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfJYVeI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 17:34:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58147 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726100AbfJYVeI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Oct 2019 17:34:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572039247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b2Q9cP6iEB8MQoJNIWjyPj/rzpIwmAS+ZTzyx7BQwQk=;
        b=HPX4V5eEyQMvknH+nBitcx5vFKJEFO/3aEfC5cqkIQnflJXYy0xAoJapVXD7ViEHlSw7uO
        CSDHEhzRZZHV5m+eTQAQYS1LhUKdGqOKlMsPnxSvDpNXddnRNFOT/XO5rQqTs08DcAdZfg
        wSeyIyDyw2aX1zSyDhtXdCh1prmxcEI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-rnjRWb6PNtSuoAN50o6m0A-1; Fri, 25 Oct 2019 17:34:05 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37F0D800D49;
        Fri, 25 Oct 2019 21:34:04 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD8775C1B5;
        Fri, 25 Oct 2019 21:34:03 +0000 (UTC)
Message-ID: <91792b372569056b5e825f314ada61e09bb33e77.camel@redhat.com>
Subject: Re: [PATCH] lpfc: fix spelling error in MAGIC_NUMER_xxx
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>
Date:   Fri, 25 Oct 2019 17:34:03 -0400
In-Reply-To: <20191025184342.6623-1-jsmart2021@gmail.com>
References: <20191025184342.6623-1-jsmart2021@gmail.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: rnjRWb6PNtSuoAN50o6m0A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2019-10-25 at 11:43 -0700, James Smart wrote:
> convert MAGIC_NUMER_xxx to MAGIC_NUMBER_xxx
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/lpfc/lpfc_hw4.h  | 4 ++--
>  drivers/scsi/lpfc/lpfc_init.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
> index d40bfe5aa21f..9daa2b494b5c 100644
> --- a/drivers/scsi/lpfc/lpfc_hw4.h
> +++ b/drivers/scsi/lpfc/lpfc_hw4.h
> @@ -4822,8 +4822,8 @@ union lpfc_wqe128 {
>  =09struct send_frame_wqe send_frame;
>  };
> =20
> -#define MAGIC_NUMER_G6 0xFEAA0003
> -#define MAGIC_NUMER_G7 0xFEAA0005
> +#define MAGIC_NUMBER_G6 0xFEAA0003
> +#define MAGIC_NUMBER_G7 0xFEAA0005
> =20
>  struct lpfc_grp_hdr {
>  =09uint32_t size;
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.=
c
> index 686677dd52a4..9536ad3cc4ee 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -12418,9 +12418,9 @@ lpfc_log_write_firmware_error(struct lpfc_hba *ph=
ba, uint32_t offset,
>  =09 */
>  =09if (offset =3D=3D ADD_STATUS_FW_NOT_SUPPORTED ||
>  =09    (phba->pcidev->device =3D=3D PCI_DEVICE_ID_LANCER_G6_FC &&
> -=09     magic_number !=3D MAGIC_NUMER_G6) ||
> +=09     magic_number !=3D MAGIC_NUMBER_G6) ||
>  =09    (phba->pcidev->device =3D=3D PCI_DEVICE_ID_LANCER_G7_FC &&
> -=09     magic_number !=3D MAGIC_NUMER_G7)) {
> +=09     magic_number !=3D MAGIC_NUMBER_G7)) {
>  =09=09lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
>  =09=09=09=09"3030 This firmware version is not supported on"
>  =09=09=09=09" this HBA model. Device:%x Magic:%x Type:%x "

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

