From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] [SCSI] st: Remove obsolete scsi_tape.max_pfn
Date: Tue, 17 Nov 2015 10:01:02 -0500
Message-ID: <1447772462.4067.3.camel@localhost.localdomain>
References: <1447588113-21117-1-git-send-email-geert@linux-m68k.org>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447588113-21117-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kai =?ISO-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2015-11-15 at 12:48 +0100, Geert Uytterhoeven wrote:
> Its last user was removed 10 years ago, in commit
> 8b05b773b6030de5 ("[SCSI] convert st to use scsi_execute_async").
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/scsi/st.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
> index b6486b5d86811227..8c732c8de0153eb1 100644
> --- a/drivers/scsi/st.h
> +++ b/drivers/scsi/st.h
> @@ -148,8 +148,6 @@ struct scsi_tape {
>  	int tape_type;
>  	int long_timeout;	/* timeout for commands known to take long time */
>  
> -	unsigned long max_pfn;	/* the maximum page number reachable by the HBA */
> -
>  	/* Mode characteristics */
>  	struct st_modedef modes[ST_NBR_MODES];
>  	int current_mode;

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
