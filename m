From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 3/3] ahci_xgene: Fix the link down in first attempt
 for the APM X-Gene SoC AHCI SATA host controller driver.
Date: Sat, 6 Sep 2014 11:28:09 +0900
Message-ID: <20140906022809.GB21579@mtj.dyndns.org>
References: <1409217682-5759-1-git-send-email-stripathi@apm.com>
 <1409217682-5759-4-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1409217682-5759-4-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 28, 2014 at 02:51:22PM +0530, Suman Tripathi wrote:
> Due to HW errata the APM X-Gene AHCI SATA host controller reports link
> down even if the device presence is detected. This issue is due to speed
> negotiation failure. This patch implements the algorithm to retry the
> COMRESET if PxSTAT register reports device presence detected but
> PHY communication not established. The maximum retry attempts are 3.
> 
> This patch also fixes the code to match the algorithm for the printing
> a warning message if the disparity error still exists after link up.
> 
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>

Applied to libata/for-3.17-fixes.

Thanks.

-- 
tejun
