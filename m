From: Jeremiah Mahler <jmmahler@gmail.com>
Subject: Re: [PATCH] scsi: arm: cumana_1.c:  Remove unused function
Date: Sat, 20 Dec 2014 08:50:45 -0800
Message-ID: <20141220165045.GA5013@hudson.localdomain>
References: <1419093375-8016-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1419093375-8016-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, Russell King <linux@arm.linux.org.uk>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Dec 20, 2014 at 05:36:15PM +0100, Rickard Strandqvist wrote:
> Remove the function cumanascsi_setup() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/scsi/arm/cumana_1.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
> index 8ef810a..7c90d9c 100644
> --- a/drivers/scsi/arm/cumana_1.c
> +++ b/drivers/scsi/arm/cumana_1.c
> @@ -38,10 +38,6 @@
>  
>  #include "../NCR5380.h"
>  
> -void cumanascsi_setup(char *str, int *ints)
> -{
> -}
> -
>  const char *cumanascsi_info(struct Scsi_Host *spnt)
>  {
>  	return "";
[...]

You can blame Linus for this one :-)

~/linux-next$ git blame -L 38,40 drivers/scsi/arm/cumana_1.c 
^1da177e (Linus Torvalds 2005-04-16 15:20:36 -0700 38) void
cumanascsi_setup(char *str, int *ints)
^1da177e (Linus Torvalds 2005-04-16 15:20:36 -0700 39) {
^1da177e (Linus Torvalds 2005-04-16 15:20:36 -0700 40) }
~/linux-next$

-- 
- Jeremiah Mahler
