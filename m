From: Feng Li <lifeng1519@gmail.com>
Subject: Re: [PATCH] smartpqi: Fix timeout of smartpqi probe stage
Date: Fri, 19 Oct 2018 16:02:08 +0800
Message-ID: <CAEK8JBDHAaAcjZ0GhQLY_q7Q5=hPPXzJsPkC3ziTZKHQoOJ0YA@mail.gmail.com>
References: <CAEK8JBAgRwHZDBrNDNmmRXC3WgX9tVqeoFk5edLHfJL9OWQ-zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAEK8JBAgRwHZDBrNDNmmRXC3WgX9tVqeoFk5edLHfJL9OWQ-zg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: fengli@smartx.com
List-Id: linux-scsi@vger.kernel.org

Just Ping.
This is a very serious issue. The OS boot from this raid controller
couldn't find bock devices after installing OS.

I think this patch should be merged asap.

Feng Li <lifeng1519@gmail.com> =E4=BA=8E2018=E5=B9=B410=E6=9C=8812=E6=97=A5=
=E5=91=A8=E4=BA=94 =E4=B8=8A=E5=8D=8811:13=E5=86=99=E9=81=93=EF=BC=9A
>
> I use 'HPE Smart Array E208i-a SR Gen10 Controller', and pass through
> the SAS controller from ESXi 6.0U1 to VM, which is installed CentOS 7.4/7=
.5.
> The disk is not found.
>
> The error log is "controller not ready after 30 seconds."
>
> Add some logs, and could check the probe stage needs nearly 36s to match =
the
> status.
>
> Signed-off-by: Li Feng <fengli@smartx.com>
> ---
>  drivers/scsi/smartpqi/smartpqi_sis.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c
> b/drivers/scsi/smartpqi/smartpqi_sis.c
> index 5141bd4c9..bc7efdacb 100644
> --- a/drivers/scsi/smartpqi/smartpqi_sis.c
> +++ b/drivers/scsi/smartpqi/smartpqi_sis.c
> @@ -59,7 +59,7 @@
>
>  #define SIS_CTRL_KERNEL_UP 0x80
>  #define SIS_CTRL_KERNEL_PANIC 0x100
> -#define SIS_CTRL_READY_TIMEOUT_SECS 30
> +#define SIS_CTRL_READY_TIMEOUT_SECS 90
>  #define SIS_CTRL_READY_RESUME_TIMEOUT_SECS 90
>  #define SIS_CTRL_READY_POLL_INTERVAL_MSECS 10
>
> --
> 2.11.0



--=20
Thanks and Best Regards,
Feng Li(Alex)
