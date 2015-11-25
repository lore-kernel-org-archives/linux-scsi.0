From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 5/5] arcmsr: changes driver version number
Date: Wed, 25 Nov 2015 13:08:53 +0100
Message-ID: <5655A4D5.1050606@suse.de>
References: <1448452335.4670.47.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448452335.4670.47.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>, hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de
Cc: hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On 11/25/2015 12:52 PM, Ching Huang wrote:
> From: Ching Huang <ching2048@areca.com.tw>
>=20
> Changes driver version number.
>=20
> Signed-of-by: Ching Huang <ching2048@areca.com.tw>
>=20
> ---
>=20
> diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcms=
r.h
> --- a/drivers/scsi/arcmsr/arcmsr.h	2015-11-25 18:25:42.926038000 +080=
0
> +++ b/drivers/scsi/arcmsr/arcmsr.h	2015-11-25 18:04:27.400075000 +080=
0
> @@ -52,7 +52,7 @@ struct device_attribute;
>  	#define ARCMSR_MAX_FREECCB_NUM	320
>  #define ARCMSR_MAX_OUTSTANDING_CMD	255
>  #endif
> -#define ARCMSR_DRIVER_VERSION		"v1.30.00.04-20140919"
> +#define ARCMSR_DRIVER_VERSION		"v1.30.00.21-20151019"
>  #define ARCMSR_SCSI_INITIATOR_ID						255
>  #define ARCMSR_MAX_XFER_SECTORS							512
>  #define ARCMSR_MAX_XFER_SECTORS_B						4096
>=20
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
