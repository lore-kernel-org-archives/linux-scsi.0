From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/2] ibmvscsi: add vscsi hosts to global list_head
Date: Thu, 8 Dec 2016 10:04:06 +0100
Message-ID: <20161208090406.GA4789@linux-x5ow.site>
References: <1481148276-5083-1-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33863 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751959AbcLHJEZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Dec 2016 04:04:25 -0500
Content-Disposition: inline
In-Reply-To: <1481148276-5083-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, nfont@linux.vnet.ibm.com

On Wed, Dec 07, 2016 at 04:04:35PM -0600, Tyrel Datwyler wrote:
> Add each vscsi host adatper to a new global list_head named
> ibmvscsi_head. There is no functional change. This is meant primarily
> as a convience for locating adatpers from within the debugger or crash
> utility.
> 
> Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
