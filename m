From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/2] ibmvscsi: log bad SRP response opcode in hex format
Date: Thu, 8 Dec 2016 10:04:19 +0100
Message-ID: <20161208090419.GB4789@linux-x5ow.site>
References: <1481148276-5083-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <1481148276-5083-2-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33891 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751905AbcLHJEZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Dec 2016 04:04:25 -0500
Content-Disposition: inline
In-Reply-To: <1481148276-5083-2-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, nfont@linux.vnet.ibm.com

On Wed, Dec 07, 2016 at 04:04:36PM -0600, Tyrel Datwyler wrote:
> An unrecogonized or unsupported SRP response has its opcode currently
> logged in decimal format. Log it in hex format instead so it can easily
> be validated against the SRP specs values which are in hex.
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
