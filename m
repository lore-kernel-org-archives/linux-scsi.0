From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: replace wrong device handler name for CLARiiON arrays
Date: Tue, 11 Oct 2016 17:58:54 -0400
Message-ID: <yq11szmo8dd.fsf@sermon.lab.mkp.net>
References: <20161007161957.6042-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48283 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754269AbcJKV7s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Oct 2016 17:59:48 -0400
In-Reply-To: <20161007161957.6042-1-xose.vazquez@gmail.com> (Xose Vazquez
        Perez's message of "Fri, 7 Oct 2016 18:19:57 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>

>>>>> "Xose" == Xose Vazquez Perez <xose.vazquez@gmail.com> writes:

Xose> At drivers/scsi/device_handler/scsi_dh_emc.c it was defined as:
Xose> #define CLARIION_NAME "emc"

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
