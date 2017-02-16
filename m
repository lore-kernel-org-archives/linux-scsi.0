From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/10] mpt3sas: open-code _scsih_scsi_lookup_get()
Date: Thu, 16 Feb 2017 11:04:24 +0100
Message-ID: <ee7da2a5-e658-6875-c373-a5b117e4000d@suse.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
 <1485854760-122683-6-git-send-email-hare@suse.de>
 <CAK=zhgqrBZPUSvDKHEMZwHLWv00DCrnRzKAsUE+AbyH0M4XoTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40773 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753514AbdBPKE0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 05:04:26 -0500
In-Reply-To: <CAK=zhgqrBZPUSvDKHEMZwHLWv00DCrnRzKAsUE+AbyH0M4XoTQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, Hannes Reinecke <hare@suse.com>

On 02/16/2017 10:59 AM, Sreekanth Reddy wrote:
> On Tue, Jan 31, 2017 at 2:55 PM, Hannes Reinecke <hare@suse.de> wrote:
>> Just a wrapper around the scsi lookup array and only used
>> in one place, so open-code it.
> 
> I think this whole series of patches created over 14.101.00.00 version
> driver not on the latest 15.100.00.00 driver. So this patch will
> conflict with 15.100.00.00 version driver i.e. with commit
> 459325c466d278d3c9f51ddc9bb544c014136fd1(mpt3sas: Fix for Crusader to
> achieve product targets with SAS devices).
> 
Correct, I just noticed it.
Will be rebasing it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
