From: Olaf Hering <ohering@suse.com>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Get rid of warning messages
Date: Wed, 17 Sep 2014 09:33:24 +0200
Message-ID: <20140917073324.GB23716@suse.com>
References: <1409701396-20226-1-git-send-email-kys@microsoft.com>
 <20140905054014.GA11595@infradead.org>
 <155acb7b8a3d4532aaa280e44f62447f@BY2PR0301MB0711.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbaIQHd2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Sep 2014 03:33:28 -0400
Content-Disposition: inline
In-Reply-To: <155acb7b8a3d4532aaa280e44f62447f@BY2PR0301MB0711.namprd03.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Sep 08, KY Srinivasan wrote:

> > -----Original Message-----
> > From: Christoph Hellwig [mailto:hch@infradead.org]
> > Sent: Thursday, September 4, 2014 10:40 PM
> > To: KY Srinivasan
> > Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Get rid of warning messages
> > 
> > Looks good to me.
> > 
> > Olaf, Hannes - can I get another review for this (and the older hyperv
> > scanning patch set)?

Christoph,

what does "review of this" mean?  There are many hv related patches
floating around.  The removal of the warning in msgid
<1409701396-20226-1-git-send-email-kys@microsoft.com> looks ok to me.

Olaf
