From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH] scsi: pm8001: pm80xx_hwi.c:  Cleaning up variable is
 set more than once
Date: Thu, 26 Jun 2014 10:09:00 +0200
Message-ID: <53ABD51C.5050806@gmail.com>
References: <1403704907-25672-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1403704907-25672-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Cc: lindar_liu@usish.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Thanks Rickard,

>From my point of view, looks good, but I'd like to get review from Anand
(cc-ed).

Anand, could you share your opinion?

Regards,
Jack

On 06/25/2014 04:01 PM, Rickard Strandqvist wrote:
> A struct member variable is set to different values without having used in between.
> 
> This was found using a static code analysis program called cppcheck
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index d70587f..2698227 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -249,7 +249,6 @@ moreData:
>  				sprintf(pm8001_ha->
>  					forensic_info.data_buf.direct_data,
>  						"%08x ", 4);
> -			pm8001_ha->forensic_info.data_buf.read_len = 0xFFFFFFFF;
>  			pm8001_ha->forensic_info.data_buf.direct_len =  0;
>  			pm8001_ha->forensic_info.data_buf.direct_offset = 0;
>  			pm8001_ha->forensic_info.data_buf.read_len = 0;
> 
