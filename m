From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] ahci_xgene: Fix the dma state machine lockup for the
 ATA_CMD_SMART PIO mode command.
Date: Tue, 27 Jan 2015 13:19:50 -0500
Message-ID: <20150127181950.GE12314@htj.dyndns.org>
References: <1422381371-11361-1-git-send-email-stripathi@apm.com>
 <1422381371-11361-2-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1422381371-11361-2-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 27, 2015 at 11:26:11PM +0530, Suman Tripathi wrote:
> This patch addresses the issue with ATA_CMD_SMART pio mode
> command for enumeration and device detection with ATA devices.It is the
> same issue as in patch
> 
> www.spinics.net/lists/linux-ide/msg49092.html

The link is broken.  Can you please include at least a brief
explanation of the problem and preferably link to something more
permanant (commit ID, http://lkml.kernel.org/g/MSG_ID)?

Thanks.

-- 
tejun
