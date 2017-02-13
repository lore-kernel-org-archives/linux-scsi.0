From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 11/16] lpfc: NVME Target: Receive buffer updates
Date: Mon, 13 Feb 2017 10:14:37 +0100
Message-ID: <72a0cb72-35bf-eaf1-cf1a-2a1c87058438@suse.de>
References: <58a0d923.jjJfZZPzCO4ZQP5E%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40084 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751871AbdBMJOj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Feb 2017 04:14:39 -0500
In-Reply-To: <58a0d923.jjJfZZPzCO4ZQP5E%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 02/12/2017 10:52 PM, James Smart wrote:
> 
> NVME Target: Receive buffer updates
> 
> Allocates buffer pools and configures adapter interfaces to handle
> receive buffer (asynchronous FCP CMD ius, first burst data)
> from the adapter. Splits by protocol, etc.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>

I probably do _not_ want to know why 32G FC-NVMe needs to know about
FCFs ...

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
