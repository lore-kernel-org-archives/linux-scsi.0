From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 02/17 v2] lpfc: Correct embedded io wq element size
Date: Thu, 13 Oct 2016 09:49:56 +0200
Message-ID: <20161013074956.mm3bmbu7flgntm3e@linux-x5ow.site>
References: <57fe998d.sIoov/3UyUW3cY0g%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39919 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752073AbcJMHt6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 03:49:58 -0400
Content-Disposition: inline
In-Reply-To: <57fe998d.sIoov/3UyUW3cY0g%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Oct 12, 2016 at 01:14:05PM -0700, James Smart wrote:
> 
> Correct embedded io wq element size. Embedded element sizes are
> 128 byte elements
> 
> Modified per review:
> change style of selecting wqesize using local variable

This should go below the "---" line after the Signed-off-bys.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---

Otherwise,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
