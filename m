From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] lpfc: Fix nvme io stoppage after link bounce
Date: Thu, 22 Jun 2017 20:50:35 +0200
Message-ID: <20170622185035.GA3284@linux-x5ow.site>
References: <20170621173758.28058-1-jsmart2021@gmail.com>
 <20170622074142.GB5670@linux-x5ow.site>
 <7f10cbae-a88e-f5a8-d54d-a22a543438e0@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53497 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751221AbdFVSuj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jun 2017 14:50:39 -0400
Content-Disposition: inline
In-Reply-To: <7f10cbae-a88e-f5a8-d54d-a22a543438e0@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>

On Thu, Jun 22, 2017 at 08:52:14AM -0700, James Smart wrote:
> well, the primary reason is the code that was removed was bogus to begin
> with. Abort of an io/exchange, if its active, needs to occur on the link
> regardless of the ndlp state. This it simply needed to occur. As not checks
> on ndlp state are needed, there is no race.

Thanks for the explanation

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
