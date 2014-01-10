From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 00/14] target: Initial support for DIF Type1+Type3
 emulation
Date: Thu, 09 Jan 2014 21:57:25 -0800
Message-ID: <1389333445.5567.367.camel@haakon3.risingtidesystems.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	 <yq1mwj4sii9.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <yq1mwj4sii9.fsf@sermon.lab.mkp.net>
Sender: target-devel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-01-09 at 21:00 -0500, Martin K. Petersen wrote:
> >>>>> "Nic" == Nicholas A Bellinger <nab@daterainc.com> writes:
> 
> Nic> This series contains initial support for target mode DIF
> Nic> Type1+Type3 emulation within target core, RAMDISK_MCP device
> Nic> backend, and tcm_loop fabric driver.
> 
> Super cool! Do you have a git tree so I can start tinkering with this?

Most certainly, it's been pushed to target-pending/auto-next.

> 
> I'll start reviewing the pieces tomorrow.

Excellent.

Thanks MKP!

--nab
