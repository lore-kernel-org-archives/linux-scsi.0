From: Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH] lpfc: Don't return internal MBXERR_ERROR code from
 probe function
Date: Wed, 6 Sep 2017 10:47:38 +0200
Message-ID: <20170906104738.50b81cd5@elisabeth>
References: <a1464fd9d04361952cbbc031622c3259358eb8ac.1503925436.git.sbrivio@redhat.com>
        <20170906103222.538c07b2@elisabeth>
        <20170906084235.n22ll6z7pnvi6t3q@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34508 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750832AbdIFIro (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 Sep 2017 04:47:44 -0400
In-Reply-To: <20170906084235.n22ll6z7pnvi6t3q@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>, QLogic-Storage-Upstream@cavium.com, Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

On Wed, 6 Sep 2017 10:42:35 +0200
Johannes Thumshirn <jthumshirn@suse.de> wrote:

> On Wed, Sep 06, 2017 at 10:32:22AM +0200, Stefano Brivio wrote:
> > 
> > I didn't get feedback about this patch. Is there any issue with the
> > submission?
> > 
> > I think it actually fixes a quite critical issue, if initialization
> > fails we have crashes on reboot like the one reported below [1], and
> > should perhaps also be queued for -stable.  
> 
> It seems to have slipped trough the cracks, can you please re-submit?

The original submission is archived at
https://marc.info/?l=linux-scsi&m=150392554622786&w=2. Before I cause
any confusion... do you want me to re-submit this with the same
subject? As v2 with a comment?


--
Stefano
