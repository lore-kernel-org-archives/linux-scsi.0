From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Wed, 11 Jan 2017 14:46:04 +0100
Message-ID: <79efbc41-26fb-77e5-751a-05d7c811870d@suse.de>
References: <20170111134312.GH6286@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170111134312.GH6286@linux-x5ow.site>
Sender: linux-block-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: linux-block@vger.kernel.org, Linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>
List-Id: linux-scsi@vger.kernel.org

On 01/11/2017 02:43 PM, Johannes Thumshirn wrote:
> Hi all,
> 
> I'd like to attend LSF/MM and would like to discuss polling for block drivers.
> 
> Currently there is blk-iopoll but it is neither as widely used as NAPI in the
> networking field and accoring to Sagi's findings in [1] performance with
> polling is not on par with IRQ usage.
> 
> On LSF/MM I'd like to whether it is desirable to have NAPI like polling in
> more block drivers and how to overcome the currently seen performance issues.
> 
> [1] http://lists.infradead.org/pipermail/linux-nvme/2016-October/006975.html
> 
Yup.

I'm all for it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
