From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH/RFC] SCSI mid-layer suspend/resume
Date: Wed, 26 Oct 2005 06:26:46 +0200
Message-ID: <435F0586.8070803@s5r6.in-berlin.de>
References: <20051024160531.7d879a7c.randy_d_dunlap@linux.intel.com>	<435D6E47.1030409@pobox.com> <20051025142529.7b23bbc0.randy_d_dunlap@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20051025142529.7b23bbc0.randy_d_dunlap@linux.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Randy Dunlap <randy_d_dunlap@linux.intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, axboe@suse.de, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

Randy Dunlap wrote:
> How/where can I put low-level driver specific suspend/resume
> code, for PATA or SATA or usb-storage or ieee1394 or SCSI?
> What is the linkage (chain, pointers, whatever) thru the
> SCSI stack to each driver's "methods"?  Or do those not
> exist yet?

I will try to post a more concrete followup to my earlier comment
about involvement of lower levels, notably ieee1394, at the end of
the week. So far I have to say about ieee1394 that
  - "internal power management" i.e. suspend/resume of the local 1394
    host adapters seems not to fully work yet according to sparse
    reports from users (I did not test it myself under Linux 2.6 yet),
  - "external power management" i.e. management of power states of
    attached 1394 nodes is not implemented yet. I hope to implement bus
    manager contention (a prerequisite for bus-wide power management)
    in late November or in December.
-- 
Stefan Richter
-=====-=-=-= =-=- ==-=-
http://arcgraph.de/sr/
