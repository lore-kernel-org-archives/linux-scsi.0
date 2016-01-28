From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [LSF/MM TOPIC] NVMe target support
Date: Thu, 28 Jan 2016 01:19:03 -0800
Message-ID: <1453972743.6746.258.camel@haakon3.risingtidesystems.com>
References: <1453956103.6746.195.camel@haakon3.risingtidesystems.com>
	 <20160128085210.GB18023@infradead.org>
	 <1453972182.6746.248.camel@haakon3.risingtidesystems.com>
	 <20160128091149.GA10449@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160128091149.GA10449@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@infradead.org>, lsf-pc <lsf-pc@lists.linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, linux-nvme@lists.infradead.org, "Minturn, Dave B" <dave.b.minturn@intel.com>, Sagi Grimberg <sagig@mellanox.com>, Ming Lin <mlin@kernel.org>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@kernel.org>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2016-01-28 at 10:11 +0100, Christoph Hellwig wrote:
> There is a upcoming 'NVMe over Fabrics' spec, 

Yes.

> and it seems to be your are
> using the word 'fabrics' in a different context, so you might want to
> explain it in lay mans term.
> 

I mean in the context of target_core_fabric_ops and front-end driver
association with backend se_device->dev_group configfs symlinks.
Specifically how NVMe target drivers will be mapping these into the
existing TCM configfs layout.

> If I was dictator for life I'd forbid the use of the word 'fabrics'
> for any not related to textiles..

..?
