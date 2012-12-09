From: Cong Ding <dinggnu@gmail.com>
Subject: Re: [PATCH] scsi:gdth.c: fix compilation warning
Date: Sun, 9 Dec 2012 15:18:04 +0000
Message-ID: <20121209151804.GB25293@gmail.com>
References: <1354529949-8483-1-git-send-email-dinggnu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1354529949-8483-1-git-send-email-dinggnu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, Achim Leubner <achim_leubner@adaptec.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

ping!

- cong

On Mon, Dec 03, 2012 at 10:19:09AM +0000, Cong Ding wrote:
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
