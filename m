From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: fix block guard enablement on SLI3 adapters
Date: Tue, 27 Nov 2018 09:12:21 -0800
Message-ID: <be0d06ae-6860-c172-604b-25a1d1c1183c@broadcom.com>
References: <20181112085837.24450-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181112085837.24450-1-mwilck@suse.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>
Cc: Hannes Reinecke <hare@suse.de>, David Bond <dbond@suse.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 11/12/2018 12:58 AM, Martin Wilck wrote:
> Since f44ac12f1dcc, BG enablement is tracked with the
> LPFC_SLI3_BG_ENABLED bit, which is set in lpfc_get_cfgparam
> before lpfc_sli_config_sli_port() is called. The bit
> shouldn't be cleared before checking the feature.
> Based on problem analysis by David Bond.
>
> Fixes: f44ac12f1dcc "scsi: lpfc: Memory allocation error during driver start-up on power8"
> Tested-by: David Bond <dbond@suse.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Cc: stable@vger.kernel.org # 4.17.x
> Cc: stable@vger.kernel.org # 4.18.x
> Cc: stable@vger.kernel.org # 4.19.x
> ---
>   drivers/scsi/lpfc/lpfc_init.c | 6 +++++-
>   drivers/scsi/lpfc/lpfc_sli.c  | 1 -
>   2 files changed, 5 insertions(+), 2 deletions(-)
>
>
thanks

Signed-off-by:  James Smart <jsmart2021@gmail.com>

-- james
