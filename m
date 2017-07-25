From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qedi: Add ISCSI_BOOT_SYSFS to Kconfig
Date: Mon, 24 Jul 2017 22:03:27 -0400
Message-ID: <yq1vamh1de8.fsf@oracle.com>
References: <20170719090755.27946-1-nilesh.javali@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27637 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753090AbdGYCEr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2017 22:04:47 -0400
In-Reply-To: <20170719090755.27946-1-nilesh.javali@cavium.com> (Nilesh
        Javali's message of "Wed, 19 Jul 2017 02:07:55 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nilesh Javali <nilesh.javali@cavium.com>
Cc: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com, linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com


Nilesh,

> qedi uses iscsi_boot_sysfs to export the targets used for boot to
> sysfs. Select the config option to make sure the module is built.

Applied to 4.13/scsi-fixes. Whitespace was bad. Fixed.

-- 
Martin K. Petersen	Oracle Linux Engineering
