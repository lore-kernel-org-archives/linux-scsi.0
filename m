From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Wed, 11 Jan 2017 17:22:35 +0100
Message-ID: <2aff05af-5e83-7d3d-f879-2cce02b6d88c@suse.de>
References: <20170111134312.GH6286@linux-x5ow.site>
 <1484150893.2619.1.camel@sandisk.com> <20170111161238.GA18881@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40478 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1765546AbdAKQWj (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
        Wed, 11 Jan 2017 11:22:39 -0500
In-Reply-To: <20170111161238.GA18881@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "Linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, "keith.busch@intel.com" <keith.busch@intel.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "sagi@grimberg.me" <sagi@grimberg.me>

On 01/11/2017 05:12 PM, hch@infradead.org wrote:
> On Wed, Jan 11, 2017 at 04:08:31PM +0000, Bart Van Assche wrote:
>> A typical Ethernet network adapter delays the generation of an interrupt
>> after it has received a packet. A typical block device or HBA does not delay
>> the generation of an interrupt that reports an I/O completion.
> 
> NVMe allows for configurable interrupt coalescing, as do a few modern
> SCSI HBAs.

Essentially every modern SCSI HBA does interrupt coalescing; otherwise
the queuing interface won't work efficiently.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
