From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 12/37] smartpqi: change functions to inline
Date: Tue, 25 Apr 2017 20:07:45 +0000
Message-ID: <1493150863.2628.14.camel@sandisk.com>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
         <149314962544.13903.85998539939893843.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:31653 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1953910AbdDYUHy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2017 16:07:54 -0400
In-Reply-To: <149314962544.13903.85998539939893843.stgit@brunhilda>
Content-Language: en-US
Content-ID: <89C5CDB6D79E4F46A5632BE5D99D60B8@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "Viswas.G@microsemi.com" <Viswas.G@microsemi.com>, "gerry.morong@microsemi.com" <gerry.morong@microsemi.com>, "Mahesh.Rajashekhara@microsemi.com" <Mahesh.Rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, "scott.benesh@microsemi.com" <scott.benesh@microsemi.com>, "don.brace@microsemi.com" <don.brace@microsemi.com>, "bader.alisaleh@microsemi.com" <bader.alisaleh@microsemi.com>, "Kevin.Barnett@microsemi.com" <Kevin.Barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, "scott.teel@microsemi.com" <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "Justin.Lindley@microsemi.com" <Justin.Lindley@microsemi.com>, "john.hall@microsemi.com" <john.hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2017-04-25 at 14:47 -0500, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@hpe.com>
>=20
> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>
> ---
>  drivers/scsi/smartpqi/smartpqi_init.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpq=
i/smartpqi_init.c
> index 728db8f..523b730 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -432,7 +432,7 @@ static struct pqi_io_request *pqi_alloc_io_request(
>  	return io_request;
>  }
> =20
> -static void pqi_free_io_request(struct pqi_io_request *io_request)
> +static inline void pqi_free_io_request(struct pqi_io_request *io_request=
)
>  {
>  	atomic_dec(&io_request->refcount);
>  }

A patch description should not only explain what has been changed but also
why a change has been made. What is the reason that this function has been
declared inline? Why do you think that the compiler is not smart enough to
decide on its own to inline this function?

Thanks,

Bart.=
