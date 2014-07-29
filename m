From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 0/4]ata: Fixes related to APM X-Gene SATA host
 controller driver.
Date: Tue, 29 Jul 2014 10:26:48 -0400
Message-ID: <20140729142648.GA4791@htj.dyndns.org>
References: <1406616892-30273-1-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1406616892-30273-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 29, 2014 at 12:24:48PM +0530, Suman Tripathi wrote:
> This patch set contains a couple of fixes related to APM X-Gene SATA
> controller driver.
> 
> v2 Change:
>    1. Drop the Link down retry patch from this patch set.
> 
> v4 Change:
>    1. Drop the patch to fix the csr-mask in dts for PHY clock
>      node of SATA Host Controller 1.
>    2. Add the patch to correct the OOB tunning parameters for
>      the COMINIT/COMWAKE parameters.
>    3. Add the patch to remove the NCQ support from the APM
>      X-Gene AHCI SATA Host controller driver.
>    4. Add the patch to remove the clock and PHY reference nodes
>      from the APM X-Gene Host controller dts node.
> 
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>

Applied 1 and 3 to libata/for-3.17.  4 doesn't apply.  Also, please
prefix the patches with "ahci_xgene: " from now on.

Thanks.

-- 
tejun
