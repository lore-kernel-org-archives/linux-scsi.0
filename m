From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 1/1] qedi: Add support for Boot from SAN over iSCSI offload
Date: Wed, 12 Jul 2017 17:06:11 -0400
Message-ID: <yq1zic9l60s.fsf@oracle.com>
References: <20170627092656.24117-1-nilesh.javali@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34918 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbdGLVGZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2017 17:06:25 -0400
In-Reply-To: <20170627092656.24117-1-nilesh.javali@cavium.com> (Nilesh
        Javali's message of "Tue, 27 Jun 2017 02:26:56 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nilesh Javali <nilesh.javali@cavium.com>
Cc: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com, linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com


Nilesh,

> This patch adds support for Boot from SAN over iSCSI offload.
> The iSCSI boot information in the NVRAM is populated under
> /sys/firmware/iscsi_bootX/ using qed NVM-image reading API and
> further exported to open-iscsi to perform iSCSI login enabling
> boot over offload iSCSI interface in a Boot from SAN environment.

Applied to 4.13/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
