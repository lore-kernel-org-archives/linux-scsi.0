From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 1/2] ahci_xgene: Removing NCQ support from the APM
 X-Gene SoC AHCI SATA Host Controller driver.
Date: Sat, 16 Aug 2014 09:09:45 -0400
Message-ID: <20140816130945.GI9305@htj.dyndns.org>
References: <1407514466-25312-1-git-send-email-stripathi@apm.com>
 <1407514466-25312-2-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1407514466-25312-2-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 08, 2014 at 09:44:25PM +0530, Suman Tripathi wrote:
> This patch removes the NCQ support from the APM X-Gene SoC AHCI
> Host Controller driver as it doesn't support it.
> 
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>

Applied to libata/for-3.17-fixes w/ stable cc'd.

Thanks.

-- 
tejun
