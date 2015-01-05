From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] ahci_xgene: Fix the dma state machine lockup for the
 ATA_CMD_PACKET PIO mode command.
Date: Mon, 5 Jan 2015 08:59:10 -0500
Message-ID: <20150105135910.GD15833@htj.dyndns.org>
References: <1418748575-27301-1-git-send-email-stripathi@apm.com>
 <1418748575-27301-3-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1418748575-27301-3-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 16, 2014 at 10:19:35PM +0530, Suman Tripathi wrote:
> This patch addresses the issue with ATA_CMD_PACKET pio mode
> command for enumeration and device detection with ATAPI devices.It is the
> same issue as in patch
> 
> www.spinics.net/lists/linux-ide/msg49092.html
> 
> Signed-off-by: Suman Tripathi <stripathi@apm.com>

Applied 1-2 to libata/for-3.18-fixes w/ Sergei's suggested edits.

Thanks.

-- 
tejun
