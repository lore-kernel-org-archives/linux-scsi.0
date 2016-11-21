From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH 1/2] hpsa: cleanup sas_phy structures in sysfs when
 unloading
Date: Mon, 21 Nov 2016 16:13:26 +0100
Message-ID: <1479741206.25031.27.camel@suse.de>
References: <20161121140429.12788-1-mwilck@suse.de>
         <20161121140429.12788-2-mwilck@suse.de>
         <20161121141336.gkc35pjmlojhxm35@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51654 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754527AbcKUPNe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Nov 2016 10:13:34 -0500
In-Reply-To: <20161121141336.gkc35pjmlojhxm35@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, martin.petersen@oracle.com
Cc: don.brace@pmcs.com, storagedev@pmcs.com, linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, hch@lst.de, hare@suse.de

On Mon, 2016-11-21 at 15:13 +0100, Johannes Thumshirn wrote:
> On Mon, Nov 21, 2016 at 03:04:28PM +0100, Martin Wilck wrote:
> > When the hpsa module is unloaded using rmmod, dangling
> > symlinks remain under /sys/class/sas_phy. Fix this by
> > calling sas_phy_delete() rather than sas_phy_free (which,
> > according to comments, should not be called for PHYs that
> > have been set up successfully, anyway).
> > 
> > References: bsc#1010946.
> 
> I don't think the SUSE bugzilla tag is of relevance upstream. But for
> sake of
> completeness we could add a 
> Link: https://bugzilla.suse.com/show_bug.cgi?id=1010946

I am sorry for this mistake.

@Martin, do you want me to re-submit with these references fixed?

I also apologize for the broken cc list of the first series, I hope I
got it right this time.

Regards
Martin


> 
> > Signed-off-by: Martin Wilck <mwilck@suse.de>
> 
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

