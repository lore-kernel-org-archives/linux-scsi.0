From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RESEND 0/6] hpsa: support legacy boards
Date: Thu, 10 Aug 2017 09:29:36 +0200
Message-ID: <c2c774af-969e-c125-7862-df50218ee481@suse.de>
References: <1502181315-102499-1-git-send-email-hare@suse.de>
 <4993A297653ECB4581FA5C3C31323D195B8C9FAB@avsrvexchmbx2.microsemi.net>
 <271fd4b5-046f-2c74-4af8-60f225744313@suse.de>
 <20170810070904.GA20910@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42803 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752401AbdHJH3i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 03:29:38 -0400
In-Reply-To: <20170810070904.GA20910@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 08/10/2017 09:09 AM, Christoph Hellwig wrote:
> No device support in Linux is unsupported, sorry.  I think we're
> getting into the corporate bullshit game a little too much here.
> 
Well, yes and no.

My intention with the 'unsupported' flag was to differentiate legit
errors / warnings from known / expected failures.

Modern (or 'supported' as Don puts it) boards have quite some features
built in, and any failure to activate these features should be debugged.
Older (or 'unsupported') boards might not necessarily have these
features, so a failure here is actually to be expected, seeing that a
firmware update for these boards is not likely to happen.

And this was precisely the meaning of the 'unsupported' flag; if that is
set we'll blank out some known warnings or short-circuit feature
detections which are known not to be present. Plus we have a marker
(and, with the latest patch, even a dmesg warning) letting us
differentiate between legit errors and unsupported/unimplemented features.

Personally I'm happy to support the legacy side of things (ie blanking
out errors from unsupported controllers), if that is of any help ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
