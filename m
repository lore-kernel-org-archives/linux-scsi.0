From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/2] hpsa: cleanup sas_phy structures in sysfs when
 unloading
Date: Tue, 22 Nov 2016 09:10:46 +0100
Message-ID: <20161122081046.fof6myjuexkgw75b@linux-x5ow.site>
References: <20161121140429.12788-1-mwilck@suse.de>
 <20161121140429.12788-2-mwilck@suse.de>
 <20161121141336.gkc35pjmlojhxm35@linux-x5ow.site>
 <yq1lgwcyy47.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53161 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752101AbcKVIKt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Nov 2016 03:10:49 -0500
Content-Disposition: inline
In-Reply-To: <yq1lgwcyy47.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Martin Wilck <mwilck@suse.de>, don.brace@pmcs.com, storagedev@pmcs.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, JBottomley@odin.com, hch@lst.de, hare@suse.de

On Mon, Nov 21, 2016 at 10:47:20PM -0500, Martin K . Petersen wrote:
> >>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:
> 
> Johannes> I don't think the SUSE bugzilla tag is of relevance upstream.
> 
> Nope. I'd rather have really comprehensive patch descriptions.
> 
> Johannes> But for sake of completeness we could add a Link:
> Johannes> https://bugzilla.suse.com/show_bug.cgi?id=1010946
> 
> "You are not authorized to access bug #1010946. To see this bug, you
> must first log in to an account with the appropriate permissions."

I'm sorry, I always thought that the bugs are visible from the outside if
we don't mark it as closed. I'm sorry, apparently it's only the openSUSE
bugs which are visible.

	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
