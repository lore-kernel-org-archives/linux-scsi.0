From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 6/6] qedi: Add support for data path.
Date: Fri, 11 Nov 2016 17:49:50 +0100
Message-ID: <928b2b42-7174-dc04-1197-2e8f6373af51@suse.de>
References: <1478588223-16183-1-git-send-email-manish.rangankar@cavium.com>
 <1478588223-16183-7-git-send-email-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52981 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755903AbcKKQwL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Nov 2016 11:52:11 -0500
In-Reply-To: <1478588223-16183-7-git-send-email-manish.rangankar@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Manish Rangankar <manish.rangankar@cavium.com>, martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, netdev@vger.kernel.org, QLogic-Storage-Upstream@cavium.com, Yuval.Mintz@cavium.com

On 11/08/2016 07:57 AM, Manish Rangankar wrote:
> This patch adds support for data path and TMF handling.
>
> Signed-off-by: Nilesh Javali <nilesh.javali@cavium.com>
> Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
> Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
> Signed-off-by: Saurav Kashyap <saurav.kashyap@cavium.com>
> Signed-off-by: Arun Easi <arun.easi@cavium.com>
> Signed-off-by: Manish Rangankar <manish.rangankar@cavium.com>
> ---
>  drivers/scsi/qedi/qedi_fw.c    | 1272 ++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/qedi/qedi_gbl.h   |    6 +
>  drivers/scsi/qedi/qedi_iscsi.c |   13 +
>  drivers/scsi/qedi/qedi_main.c  |    4 +
>  4 files changed, 1295 insertions(+)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
