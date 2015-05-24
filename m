From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 6/9] lpfc: Fix cq_id masking problem.
Date: Sun, 24 May 2015 22:24:31 +0200
Message-ID: <20150524222431.00004b98@localhost>
References: <555f4060.Uu2ZGqqAXkqDGUog%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:61393 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbbEXUYd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 May 2015 16:24:33 -0400
In-Reply-To: <555f4060.Uu2ZGqqAXkqDGUog%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> 
> Fix cq_id masking problem.
> 
> The driver inadvertainly constrained the id space to 8 bits, when its

inadvertently, it's

> a full 16 bits from hw. This resulted in bad id's being written to the
> hardware. Resulted in symptoms such as incomplete initialization, no
> detection of link events, etc.

Sebastian
