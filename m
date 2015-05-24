From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 8/9] lpfc: Fix to drop PLOGIs from fabric node till LOGO
 processing completes
Date: Sun, 24 May 2015 22:32:58 +0200
Message-ID: <20150524223258.00003096@localhost>
References: <555f4063.eNa6hhtd/lAYXugc%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55144 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbbEXUdA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 May 2015 16:33:00 -0400
In-Reply-To: <555f4063.eNa6hhtd/lAYXugc%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> 
> Fix to drop PLOGIs from fabric node till LOGO processing completes
> 
> The domain controller PLOGI's concurrent with prior LOGO's/unreg_rpi's
> completing created a race condition where driver rpi ref count can
> inadvertantly hit 0 and the rpi attempted to be freed. This error

inadvertently

> sometimes resulted in Warning messages indicating kref.h via

warning

> lfpc_nlp_get+0x128.
> 
> Correct by dropping any new PLOGI until the prior nport state has settled.

Sebastian
