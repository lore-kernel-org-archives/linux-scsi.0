From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2] sd: Ignore sync cache failures when not supported
Date: Thu, 4 May 2017 15:19:31 +0000
Message-ID: <1493911171.2692.0.camel@sandisk.com>
References: <1493891010-24258-1-git-send-email-thierry.escande@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1493891010-24258-1-git-send-email-thierry.escande@collabora.com>
Content-Language: en-US
Content-ID: <E7F466D3AE41E44BB58A031227990993@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "thierry.escande@collabora.com" <thierry.escande@collabora.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-05-04 at 11:43 +0200, Thierry Escande wrote:
> From: Derek Basehore <dbasehore@chromium.org>
>=20
> Some external hard drives don't support the sync command even though the
> hard drive has write cache enabled. In this case, upon suspend request,
> sync cache failures are ignored if the error code in the sense header is
> ILLEGAL_REQUEST. There's not much we can do for these drives, so we
> shouldn't fail to suspend for this error case. The drive may stay
> powered if that's the setup for the port it's plugged into.

Reviewed-by: Bart van Assche <bart.vanassche@sandisk.com>=
