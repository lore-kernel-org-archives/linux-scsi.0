From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 0/2]  ata: Fix the dma state machine lockup for APM
 X-Gene SoC
Date: Tue, 8 Jul 2014 11:46:35 -0400
Message-ID: <20140708154635.GG4979@htj.dyndns.org>
References: <1404752585-915-1-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:61334 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbaGHPqm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2014 11:46:42 -0400
Content-Disposition: inline
In-Reply-To: <1404752585-915-1-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>

On Mon, Jul 07, 2014 at 10:33:03PM +0530, Suman Tripathi wrote:
> This patch addresses the dma state machine lockup for APM X-Gene SoC.
> 
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>

Applied to libata/for-3.16-fixes.

Thanks.

-- 
tejun
