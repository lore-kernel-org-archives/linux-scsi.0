From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 1/2] ata: Fix the watermark threshold for the APM
 X-Gene SATA host controller driver.
Date: Thu, 10 Jul 2014 10:45:34 -0400
Message-ID: <20140710144534.GA6609@htj.dyndns.org>
References: <1405000156-321-1-git-send-email-stripathi@apm.com>
 <1405000156-321-2-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1405000156-321-2-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 10, 2014 at 07:19:15PM +0530, Suman Tripathi wrote:
> This patch fixes the watermark threshold of the receive FIFO for the
> APM X-Gene SATA host controller driver.

Can you please explain what are the effects of these patches?  Patch
descriptions should include why the specific changes are being made in
addition to the description of the changes themselves.  What are the
implications of applying this patch?

Thanks.

-- 
tejun
