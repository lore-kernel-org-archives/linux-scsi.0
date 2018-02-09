From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: mpt3sas: fix oops in error handlers after shutdown/unload
Date: Fri, 09 Feb 2018 18:22:52 -0500
Message-ID: <yq1r2ptvjcj.fsf@oracle.com>
References: <1517523386-9868-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35424 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753203AbeBIXXD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Feb 2018 18:23:03 -0500
In-Reply-To: <1517523386-9868-1-git-send-email-mauricfo@linux.vnet.ibm.com>
        (Mauricio Faria de Oliveira's message of "Thu, 1 Feb 2018 20:16:26
        -0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart.VanAssche@wdc.com, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, dougmill@linux.vnet.ibm.com


> This patch adds checks for 'ioc->remove_host' in the SCSI error
> handlers, so not to access pointers/resources potentially freed
> in the PCI shutdown/module unload path.  The error handlers may
> be invoked after shutdown/unload, depending on other components.

Broadcom folks: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
