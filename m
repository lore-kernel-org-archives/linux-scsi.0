From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 4/6] qla2xxx: Add multiple queue pair functionality.
Date: Thu, 8 Dec 2016 15:29:40 +0100
Message-ID: <98b4db8a-91de-d928-bf50-68088ef260c2@suse.de>
References: <1481051266-32362-1-git-send-email-himanshu.madhani@cavium.com>
 <1481051266-32362-5-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42005 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752447AbcLHOhI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Dec 2016 09:37:08 -0500
In-Reply-To: <1481051266-32362-5-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 12/06/2016 08:07 PM, Himanshu Madhani wrote:
> From: Michael Hernandez <michael.hernandez@cavium.com>
>
> Replaced existing multiple queue functionality with framework
> that allows for the creation of pairs of request and response queues,
> either at start of day or dynamically.
>
> Queue pair creation depend on module parameter "ql2xmqsupport",
> which need to be enabled to create queue pair.
>
> Signed-off-by: Sawan Chandak <sawan.chandak@cavium.com>
> Signed-off-by: Michael Hernandez <michael.hernandez@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_attr.c   |  36 ++--
>  drivers/scsi/qla2xxx/qla_dbg.c    |   4 +-
>  drivers/scsi/qla2xxx/qla_def.h    | 105 ++++++++--
>  drivers/scsi/qla2xxx/qla_gbl.h    |  28 ++-
>  drivers/scsi/qla2xxx/qla_init.c   | 173 +++++++++++++++-
>  drivers/scsi/qla2xxx/qla_inline.h |  30 +++
>  drivers/scsi/qla2xxx/qla_iocb.c   | 407 ++++++++++++++++++++++++++++++++++----
>  drivers/scsi/qla2xxx/qla_isr.c    | 122 +++++++-----
>  drivers/scsi/qla2xxx/qla_mbx.c    |  33 ++--
>  drivers/scsi/qla2xxx/qla_mid.c    | 114 ++++++-----
>  drivers/scsi/qla2xxx/qla_os.c     | 395 ++++++++++++++++++++++++------------
>  11 files changed, 1113 insertions(+), 334 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
