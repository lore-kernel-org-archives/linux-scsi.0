From: "sayali" <sayalil@codeaurora.org>
Subject: RE: [PATCH V1 2/3] scsi: ufs: Add ufs provisioning support
Date: Wed, 6 Jun 2018 16:17:14 +0530
Message-ID: <000d01d3fd83$bee3ce60$3cab6b20$@codeaurora.org>
References: <1527849774-7623-1-git-send-email-sayalil@codeaurora.org>    <1527849774-7623-3-git-send-email-sayalil@codeaurora.org> <39ab956b95a645c6e63eb9713ea9547fdc265a22.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <39ab956b95a645c6e63eb9713ea9547fdc265a22.camel@wdc.com>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Bart Van Assche' <Bart.VanAssche@wdc.com>, vinholikatti@gmail.com, asutoshd@codeaurora.org, evgreen@chromium.org, cang@codeaurora.org, martin.petersen@oracle.com, subhashj@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

-----Original Message-----
From: Bart Van Assche [mailto:Bart.VanAssche@wdc.com]=20
Sent: Monday, June 04, 2018 2:48 PM
To: vinholikatti@gmail.com; asutoshd@codeaurora.org; =
sayalil@codeaurora.org; evgreen@chromium.org; cang@codeaurora.org; =
martin.petersen@oracle.com; subhashj@codeaurora.org; =
vivek.gautam@codeaurora.org; rnayak@codeaurora.org; =
jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 2/3] scsi: ufs: Add ufs provisioning support

On Fri, 2018-06-01 at 16:12 +0530, Sayali Lokhande wrote:
> +	qTotalRawDeviceCapacity =3D
> +		(uint64_t)geo_buf[0x0b] | ((uint64_t)geo_buf[0x0a] << 8) |
> +		((uint64_t)geo_buf[0x09] << 16) |
> +		((uint64_t)geo_buf[0x08] << 24) |
> +		((uint64_t)geo_buf[0x07] << 32) |
> +		((uint64_t)geo_buf[0x06] << 40) |
> +		((uint64_t)geo_buf[0x05] << 48) |
> +		((uint64_t)geo_buf[0x04] << 56);
> +	wEnhanced1CapAdjFac =3D
> +		(uint16_t)geo_buf[0x31] | ((uint16_t)geo_buf[0x30] << 8);

Please use get_unaligned_be*() instead of open-coding these functions.
[Sayali]Agreed. Will update.

> +		*pt++ =3D (cfg->unit[i].dNumAllocUnits >> 24) & 0xff;
> +		*pt++ =3D (cfg->unit[i].dNumAllocUnits >> 16) & 0xff;
> +		*pt++ =3D (cfg->unit[i].dNumAllocUnits >> 8) & 0xff;
> +		*pt++ =3D (cfg->unit[i].dNumAllocUnits) & 0xff;

Please use put_unaligned_be() instead of open-coding this function.
[Sayali]Agreed. Will update.

Thanks,

Bart.
