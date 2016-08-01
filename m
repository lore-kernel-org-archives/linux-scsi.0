From: Tyrel Datwyler <turtle.in.the.kernel@gmail.com>
Subject: Re: [PATCH v2] lpfc: Fix possible NULL pointer dereference
Date: Mon, 1 Aug 2016 08:45:12 -0700
Message-ID: <579F6E88.2040807@gmail.com>
References: <1469799056-7708-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:32950 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbcHAPpO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2016 11:45:14 -0400
Received: by mail-io0-f195.google.com with SMTP id y195so14235546iod.0
        for <linux-scsi@vger.kernel.org>; Mon, 01 Aug 2016 08:45:13 -0700 (PDT)
In-Reply-To: <1469799056-7708-1-git-send-email-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, James Smart <james.smart@broadcom.com>

On 07/29/2016 06:30 AM, Johannes Thumshirn wrote:
> Check for the existence of piocb->vport before accessing it.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

Reviewed-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
