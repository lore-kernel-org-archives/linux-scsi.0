From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 04/20] lpfc: Fix oops when NVME Target is discovered
 in a nonNVME environment
Date: Mon, 7 Aug 2017 10:00:24 +0200
Message-ID: <20170807080024.GH3978@linux-x5ow.site>
References: <20170805004731.1335-1-jsmart2021@gmail.com>
 <20170805004731.1335-5-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38189 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752260AbdHGIA0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Aug 2017 04:00:26 -0400
Content-Disposition: inline
In-Reply-To: <20170805004731.1335-5-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On Fri, Aug 04, 2017 at 05:47:15PM -0700, James Smart wrote:
> From: Dick Kennedy <dick.kennedy@broadcom.com>
> 
> lpfc oops when it discovers a NVME target but is configured for SCSI
> only operation. Oops is in lpfc_nvme_register_port+0x33/0x300.

Why does it even call lpfc_nvme_register_rport if it isn't configured for
handling NVMe?

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
