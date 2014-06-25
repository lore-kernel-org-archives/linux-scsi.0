From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] scsi: pm8001: pm80xx_hwi.c:  Cleaning up variable is
 set more than once
Date: Wed, 25 Jun 2014 17:34:50 +0200
Message-ID: <53AAEC1A.20905@redhat.com>
References: <1403704907-25672-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1403704907-25672-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, xjtuwjp@gmail.com, lindar_liu@usish.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This one looks good to me,

Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

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
