From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] ahci_xgene: Fix the error print invalid resource for APM
 X-Gene SoC AHCI SATA Host Controller driver.
Date: Tue, 23 Sep 2014 10:22:21 -0400
Message-ID: <20140923142221.GA19208@htj.dyndns.org>
References: <1411390893-22911-1-git-send-email-stripathi@apm.com>
 <1411390893-22911-2-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:60292 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbaIWOWZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Sep 2014 10:22:25 -0400
Content-Disposition: inline
In-Reply-To: <1411390893-22911-2-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>

On Mon, Sep 22, 2014 at 06:31:33PM +0530, Suman Tripathi wrote:
> This patch fixes the error print invalid resource for the APM X-Gene
> SoC AHCI SATA Host Controller driver. This print was due to the fact
> that the controller 3 don't have a mux resource. This didn't result
> in any errors but the print seems like meaningless.
> 
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>

Applied to libata/for-3.18.

Thanks.

-- 
tejun
