From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/2] arm64: Fix the APM X-Gene SoC SATA PHY clock DTS
 node csr-mask of the SATA Host Controller 1.
Date: Thu, 10 Jul 2014 10:46:24 -0400
Message-ID: <20140710144624.GB6609@htj.dyndns.org>
References: <1405000156-321-1-git-send-email-stripathi@apm.com>
 <1405000156-321-3-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:62593 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbaGJOq1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2014 10:46:27 -0400
Content-Disposition: inline
In-Reply-To: <1405000156-321-3-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>

On Thu, Jul 10, 2014 at 07:19:16PM +0530, Suman Tripathi wrote:
> This patch fixes the SATA PHY clock DTS node csr-mask of the
> SATA Host controller 1. This patch also fixes the status of
> the PHY clock node of SATA Host Controller 1.

Ditto.  Before, XXX was wrong and as a result YYY didn't work
properly.  This patch updates ZZZ to fix the issue.

-- 
tejun
