From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 5/5] arcmsr: changes driver version number
Date: Wed, 25 Nov 2015 13:01:23 +0100
Message-ID: <1448452883.2877.78.camel@suse.de>
References: <1448452335.4670.47.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448452335.4670.47.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: hch@lst.de, hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-11-25 at 19:52 +0800, Ching Huang wrote:
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
> =C2=A0	#define ARCMSR_MAX_FREECCB_NUM	320
> =C2=A0#define ARCMSR_MAX_OUTSTANDING_CMD	255
> =C2=A0#endif
> -#define ARCMSR_DRIVER_VERSION		"v1.30.00.04-20140919"
> +#define ARCMSR_DRIVER_VERSION		"v1.30.00.21-20151019"
> =C2=A0#define ARCMSR_SCSI_INITIATOR_ID					=09
> 255
> =C2=A0#define ARCMSR_MAX_XFER_SECTORS					=09
> 	512
> =C2=A0#define ARCMSR_MAX_XFER_SECTORS_B					=09
> 4096
>=20
>=20

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
