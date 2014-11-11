From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1/7] megaraid_sas : Driver version upgrade
Date: Tue, 11 Nov 2014 14:44:28 +0100
Message-ID: <546212BC.5070906@redhat.com>
References: <201411101224.sAACOcKw018039@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbaKKNpA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2014 08:45:00 -0500
In-Reply-To: <201411101224.sAACOcKw018039@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, aradford@gmail.com

On 11/10/2014 01:21 PM, Sumit.Saxena@avagotech.com wrote:
> megaraid_sas driver version upgrade
>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h      | 2 +-
>  drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index a49914d..f3eccf1 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -33,7 +33,7 @@
>  /*
>   * MegaRAID SAS Driver meta data
>   */
> -#define MEGASAS_VERSION				"06.805.06.00-rc1"
> +#define MEGASAS_VERSION				"06.805.06.01-rc1"
>  #define MEGASAS_RELDATE				"Sep. 4, 2014"
>  #define MEGASAS_EXT_VERSION			"Thu. Sep. 4 17:00:00 PDT 2014"

Usually you have changed the dates too, but this not important, feel free to ignore  it.

>  
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index f6a69a3..36f463c 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -18,7 +18,7 @@
>   *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
>   *
>   *  FILE: megaraid_sas_base.c
> - *  Version : 06.805.06.00-rc1
> + *  Version : 06.805.06.01-rc1
>   *
>   *  Authors: LSI Corporation
>   *           Sreenivas Bagalkote

