From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V4 11/11] megaraid_sas: driver version upgrade
Date: Fri, 9 Dec 2016 15:07:42 +0100
Message-ID: <ee5171a0-18ba-9725-d068-ee45c7de1b0f@redhat.com>
References: <1481065220-18431-1-git-send-email-sasikumar.pc@broadcom.com>
 <1481065220-18431-12-git-send-email-sasikumar.pc@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481065220-18431-12-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On 7.12.2016 00:00, Sasikumar Chandrasekaran wrote:
> Upgrade driver version.
>
> This patch is depending on patch 10
>
> Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index 7334e07..310555a 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -35,8 +35,8 @@
>  /*
>   * MegaRAID SAS Driver meta data
>   */
> -#define MEGASAS_VERSION				"06.812.07.00-rc1"
> -#define MEGASAS_RELDATE				"August 22, 2016"
> +#define MEGASAS_VERSION				"07.700.00.00-rc1"
> +#define MEGASAS_RELDATE				"November 29, 2016"
>  
>  /*
>   * Device IDs

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
