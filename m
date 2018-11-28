From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: fix block guard enablement on SLI3 adapters
Date: Wed, 28 Nov 2018 12:20:43 -0500
Message-ID: <yq1pnup2k5w.fsf@oracle.com>
References: <20181112085837.24450-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181112085837.24450-1-mwilck@suse.com> (Martin Wilck's message
        of "Mon, 12 Nov 2018 09:58:37 +0100")
Sender: stable-owner@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Smart <jsmart2021@gmail.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, Hannes Reinecke <hare@suse.de>, David Bond <dbond@suse.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Martin,

> Since f44ac12f1dcc, BG enablement is tracked with the
> LPFC_SLI3_BG_ENABLED bit, which is set in lpfc_get_cfgparam before
> lpfc_sli_config_sli_port() is called. The bit shouldn't be cleared
> before checking the feature.  Based on problem analysis by David Bond.

Applied to 4.20/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
