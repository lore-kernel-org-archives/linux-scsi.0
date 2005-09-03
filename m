From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/7] zfcp: introduce eh_timed_out handler
Date: Sat, 03 Sep 2005 14:56:50 +0200
Message-ID: <1125752211.3223.11.camel@laptopd505.fenrus.org>
References: <20050903123042.GA7902@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:59789 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750910AbVICM5G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Sep 2005 08:57:06 -0400
In-Reply-To: <20050903123042.GA7902@lion28.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <aherrman@de.ibm.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, James Bottomley <jejb@steeleye.com>

On Sat, 2005-09-03 at 14:30 +0200, Andreas Herrmann wrote:
> zfcp: introduce eh_timed_out handler
> 
> This handler is required to avoid offlined SCSI devices in a multipath
> setup if scsi commands time out on cable pulls lasting longer than 30
> seconds.


hmm why is this needed? doesn't the fc transport class do this for you
already? If not.. I think it should since it's not unique to your FC
driver but common to all..


