From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] hv_storvsc: error handling.
Date: Tue, 7 Mar 2017 06:06:24 +0100
Message-ID: <20170307050624.GA14133@lst.de>
References: <20170301174058.383da142@xeon-e3> <c8ff2b64-2421-ca45-1f89-afec0490c8b3@suse.de> <20170302102324.47dbe3ad@xeon-e3> <895c4f2e-7faa-41e1-b5de-eedb4ae0f882@email.android.com> <20170302110505.6ad2eb61@xeon-e3> <1b325703-b823-4304-9d9d-86071811e000@email.android.com> <20170303165011.53a38794@xeon-e3> <DM5PR03MB24906E9B50B16B8C567EE25BA02A0@DM5PR03MB2490.namprd03.prod.outlook.com> <20170306083619.6789f9ba@xeon-e3> <DM5PR03MB2490F80E2F703D6FD3F1AC4BA02C0@DM5PR03MB2490.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48521 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752532AbdCGJXQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Mar 2017 04:23:16 -0500
Content-Disposition: inline
In-Reply-To: <DM5PR03MB2490F80E2F703D6FD3F1AC4BA02C0@DM5PR03MB2490.namprd03.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>, James Bottomley <James.Bottomley@Hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, "Adrian Suhov (Cloudbase Solutions SRL)" <v-adsuho@microsoft.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>

> Was the invalid LUN in the LUN0 position. Inquiry of LUN0 support (when LUN0 is not populated)
> was added only recently to address host side issue.

How does HyperV expect device scanning to happen for a not populated LUN?

REPORT SUPPORTED LUNS but nothing else on LUN 0?  Maybe a TEST UNIT READY
thrown?  Or does it actually support the REPORT LUNS well known LU?
