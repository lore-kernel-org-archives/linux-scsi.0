From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 3/3] arcmsr: change driver version to
 v1.30.00.22-20151126
Date: Tue, 01 Dec 2015 14:41:48 +0100
Message-ID: <1448977308.3103.32.camel@suse.de>
References: <1448538295.10768.51.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37196 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996AbbLANlt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 08:41:49 -0500
In-Reply-To: <1448538295.10768.51.camel@Centos6.3-64>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>, thenzl@redhat.com, hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de
Cc: hch@lst.de

On Thu, 2015-11-26 at 19:44 +0800, Ching Huang wrote:
> From: Ching Huang <ching2048@areca.com.tw>
>=20
> change driver version to v1.30.00.22-20151126
>=20
> Signed-of-by: Ching Huang <ching2048@areca.com.tw>
>=20
> ---
>=20
> diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcms=
r.h
> --- a/drivers/scsi/arcmsr/arcmsr.h	2015-11-25 18:04:26.000000000 +080=
0
> +++ b/drivers/scsi/arcmsr/arcmsr.h	2015-11-26 17:11:56.000000000 +080=
0
> @@ -52,7 +52,7 @@ struct device_attribute;
> =C2=A0	#define ARCMSR_MAX_FREECCB_NUM	320
> =C2=A0#define ARCMSR_MAX_OUTSTANDING_CMD	255
> =C2=A0#endif
> -#define ARCMSR_DRIVER_VERSION		"v1.30.00.21-20151019"
> +#define ARCMSR_DRIVER_VERSION		"v1.30.00.22-20151126"
> =C2=A0#define ARCMSR_SCSI_INITIATOR_ID					=09
> 255
> =C2=A0#define ARCMSR_MAX_XFER_SECTORS					=09
> 	512
> =C2=A0#define ARCMSR_MAX_XFER_SECTORS_B					=09
> 4096
>=20
>=20

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
