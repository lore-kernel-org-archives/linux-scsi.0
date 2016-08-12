From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 13/14] lpfc: Fix lost target in pt-to-pt connect
Date: Fri, 12 Aug 2016 11:44:52 +0200
Message-ID: <20160812094452.ivyt3xfacr6wywhi@c203.arch.suse.de>
References: <57acc590.rfDBAYZ4VctGazWw%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbcHLJoz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2016 05:44:55 -0400
Content-Disposition: inline
In-Reply-To: <57acc590.rfDBAYZ4VctGazWw%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Aug 11, 2016 at 11:36:00AM -0700, James Smart wrote:
> 
> Fix lost target in pt-to-pt connect
> 
> Change reject code to something that allows a retry
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
