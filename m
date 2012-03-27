From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH] [SCSI] be2iscsi: Remove unused OFFSET_IN_PAGE() macro
Date: Tue, 27 Mar 2012 09:38:32 -0700
Message-ID: <CAL1RGDX=hd=PX=VD_xjWWau01GcG8Ox_fj-FkMV5Exom_zQ++w@mail.gmail.com>
References: <1330584109-4001-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog101.obsmtp.com ([74.125.245.70]:59805 "HELO
	na3sys010aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752432Ab2C0QjH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Mar 2012 12:39:07 -0400
Received: by obbun3 with SMTP id un3so91374obb.10
        for <linux-scsi@vger.kernel.org>; Tue, 27 Mar 2012 09:38:52 -0700 (PDT)
In-Reply-To: <1330584109-4001-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Feb 29, 2012 at 10:41 PM, Roland Dreier <roland@kernel.org> wro=
te:
> From: Roland Dreier <roland@purestorage.com>
>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
> =A0drivers/scsi/be2iscsi/be.h | =A0 =A04 ----
> =A01 files changed, 0 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
> index 1d7b976..a50b6a9 100644
> --- a/drivers/scsi/be2iscsi/be.h
> +++ b/drivers/scsi/be2iscsi/be.h
> @@ -132,10 +132,6 @@ struct be_ctrl_info {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0((u32)((((size_t)(_address) & (PAGE_SI=
ZE_4K - 1)) + =A0 =A0 \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(size) + (PAGE_SIZE_4K=
 - 1)) >> PAGE_SHIFT_4K))
>
> -/* Byte offset into the page corresponding to given address */
> -#define OFFSET_IN_PAGE(addr) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((size_t)(addr) & (PAGE_SIZE_4K-1))
> -
> =A0/* Returns bit offset within a DWORD of a bitfield */
> =A0#define AMAP_BIT_OFFSET(_struct, field) =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(((size_t)&(((_struct *)0)->field))%32=
)

ping?  the corresponding be2net patch is upstream as 97767a87f3be.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
