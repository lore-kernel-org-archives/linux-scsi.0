From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Wed, 11 Jan 2017 16:26:40 +0000
Message-ID: <1484151982.2619.6.camel@sandisk.com>
References: <20170111134312.GH6286@linux-x5ow.site>
         <1484150893.2619.1.camel@sandisk.com>
         <20170111161238.GA18881@infradead.org>
         <2aff05af-5e83-7d3d-f879-2cce02b6d88c@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <2aff05af-5e83-7d3d-f879-2cce02b6d88c@suse.de>
Content-Language: en-US
Content-ID: <F6B714DCAF15EC45B177972F4B5B57A6@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "hare@suse.de" <hare@suse.de>
Cc: "Linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, "keith.busch@intel.com" <keith.busch@intel.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "sagi@grimberg.me" <sagi@grimberg.me>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-01-11 at 17:22 +0100, Hannes Reinecke wrote:
> On 01/11/2017 05:12 PM, hch@infradead.org wrote:
> > On Wed, Jan 11, 2017 at 04:08:31PM +0000, Bart Van Assche wrote:
> > > A typical Ethernet network adapter delays the generation of an
> > > interrupt
> > > after it has received a packet. A typical block device or HBA does no=
t
> > > delay
> > > the generation of an interrupt that reports an I/O completion.
> >=20
> > NVMe allows for configurable interrupt coalescing, as do a few modern
> > SCSI HBAs.
>=20
> Essentially every modern SCSI HBA does interrupt coalescing; otherwise
> the queuing interface won't work efficiently.

Hello Hannes,

The first e-mail in this e-mail thread referred to measurements against a
block device for which interrupt coalescing was not enabled. I think that
the measurements have to be repeated against a block device for which
interrupt coalescing is enabled.

Bart.=
