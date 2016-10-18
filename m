From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: Need some pointers to debug a target hang
Date: Tue, 18 Oct 2016 19:35:22 +0200
Message-ID: <20161018173522.trhoqrcoeof4mn4w@linux-x5ow.site>
References: <20160902141419.h23stppulnyfrnkz@c203.arch.suse.de>
 <1476770275.8490.10.camel@haakon3.risingtidesystems.com>
 <20161018070134.zhyk4ljaxzmvwfs2@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39379 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753095AbcJRRfc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 13:35:32 -0400
Content-Disposition: inline
In-Reply-To: <20161018070134.zhyk4ljaxzmvwfs2@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Robert LeBlanc <robert@leblancnet.us>

On Tue, Oct 18, 2016 at 09:01:34AM +0200, Johannes Thumshirn wrote:

[...]

> > 
> > This is likely the missing SCF_ACK_KREF assignment in >= v4.1.y:
> > 
> > http://www.spinics.net/lists/target-devel/msg13530.html

Sorry to disappoint you but it didn't fix my issue. Is there any debug data I
can give you, or do you have an advice where I could start looking?

I have to admit I only tested the patch on our downstream kernel and not the
upstream kernel, I'll repeat the tests on 4.8 final tomorrow.

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
