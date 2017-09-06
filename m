From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] lpfc: Don't return internal MBXERR_ERROR code from probe
 function
Date: Wed, 6 Sep 2017 10:52:51 +0200
Message-ID: <20170906085251.mq24hramagculo5y@linux-x5ow.site>
References: <a1464fd9d04361952cbbc031622c3259358eb8ac.1503925436.git.sbrivio@redhat.com>
 <20170906103222.538c07b2@elisabeth>
 <20170906084235.n22ll6z7pnvi6t3q@linux-x5ow.site>
 <20170906104738.50b81cd5@elisabeth>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53345 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752021AbdIFIwx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 Sep 2017 04:52:53 -0400
Content-Disposition: inline
In-Reply-To: <20170906104738.50b81cd5@elisabeth>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>, QLogic-Storage-Upstream@cavium.com, Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

On Wed, Sep 06, 2017 at 10:47:38AM +0200, Stefano Brivio wrote:
> The original submission is archived at
> https://marc.info/?l=linux-scsi&m=150392554622786&w=2. Before I cause
> any confusion... do you want me to re-submit this with the same
> subject? As v2 with a comment?

[PATCH RESEND] should be OK

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
