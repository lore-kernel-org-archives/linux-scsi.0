From: Cong Ding <dinggnu@gmail.com>
Subject: Re: [PATCH] scsi:gdth.c: fix compilation warning
Date: Fri, 18 Jan 2013 22:01:47 +0100
Message-ID: <CAM3j68oEfufFht7Rv3fWvMwS=QCfqv2J=HakKLHd1=LHUJeprA@mail.gmail.com>
References: <1354529949-8483-1-git-send-email-dinggnu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1354529949-8483-1-git-send-email-dinggnu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, Achim Leubner <achim_leubner@adaptec.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cong Ding <dinggnu@gmail.com>, sfr@canb.auug.org.au, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

Hi all, is this still in the queue or...?

- cong

On Mon, Dec 3, 2012 at 11:19 AM, Cong Ding <dinggnu@gmail.com> wrote:
> We do not allow old-style function definition.  Always spell foo(void) if
> a function does not take any parameters.
>
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  drivers/scsi/gdth.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index 5d72274..950c095 100644
> --- a/drivers/scsi/gdth.c
> +++ b/drivers/scsi/gdth.c
> @@ -204,7 +204,7 @@ static char strbuf[MAX_SERBUF+1];
>  #else
>  #define COM_BASE 0x3f8
>  #endif
> -static void ser_init()
> +static void ser_init(void)
>  {
>      unsigned port=COM_BASE;
>
> --
> 1.7.4.5
>
