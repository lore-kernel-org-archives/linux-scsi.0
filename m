From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 3/4] ata: add APM X-Gene SoC 6.0Gbps SATA PHY driver
Date: Wed, 20 Nov 2013 16:41:19 +0100
Message-ID: <201311201641.20230.arnd@arndb.de>
References: <1384905197-3566-1-git-send-email-lho@apm.com> <1384905197-3566-4-git-send-email-lho@apm.com> <20131120150658.GB28946@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:57614 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab3KTPlz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2013 10:41:55 -0500
In-Reply-To: <20131120150658.GB28946@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Tejun Heo <tj@kernel.org>, Loc Ho <lho@apm.com>, devicetree@vger.kernel.org, Suman Tripathi <stripathi@apm.com>, linux-scsi@vger.kernel.org, jcm@redhat.com, linux-ide@vger.kernel.org, olof@lixom.net, Tuan Phan <tphan@apm.com>

On Wednesday 20 November 2013, Tejun Heo wrote:
> On Tue, Nov 19, 2013 at 04:53:16PM -0700, Loc Ho wrote:
> > This patch adds support for APM X-Gene SoC 6.0Gbps SATA PHY. This is the
> > physical layer interface for the corresponding SATA host controller. This
> > driver uses the new PHY generic framework posted by Kishon Vijay Abrahm.
> 
> Hmm... this is related to ahci but isn't even a libata driver and is
> the first such driver proposed.  Are we sure drivers/ata is the best
> home for this?  Shouldn't we create a separate directory somewhere?
> It's confusing, at least to me, to have non-libata driver under
> drivers/ata.

It needs to be in drivers/phy, which is currently being prepared for
the next merge window and which contains the generic interface used
in this driver.

	Arnd
