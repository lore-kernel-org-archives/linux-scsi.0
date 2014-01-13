From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 14/14] tcm_loop: Enable DIF/DIX modes in SCSI host LLD
Date: Mon, 13 Jan 2014 10:45:11 -0800
Message-ID: <1389638711.5567.437.camel@haakon3.risingtidesystems.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	 <1389212157-14540-15-git-send-email-nab@daterainc.com>
	 <yq1wqi7pmrd.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <yq1wqi7pmrd.fsf@sermon.lab.mkp.net>
Sender: target-devel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-01-10 at 16:09 -0500, Martin K. Petersen wrote:
> >>>>> "nab" == Nicholas A Bellinger <nab@daterainc.com> writes:
> 
> nab> This patch updates tcm_loop_driver_probe() to set protection
> nab> information using scsi_host_set_prot() and scsi_host_set_guard(),
> nab> which currently enabled all modes of DIF/DIX protection, minus DIF
> nab> TYPE0.
> 
> ITYM, DIX Type 0.

Yes.  Fixed up the commit message.

>  And ideally you'd have a way to choose between IP and
> T10 CRC for the guard type.
> 

Sure, this can be exposed at a tcm_loop configfs attribute that is
accessible after scsi_add_host() has been called, which I assume is OK
to do..

--nab
