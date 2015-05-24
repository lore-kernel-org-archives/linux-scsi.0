From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 3/9] lpfc: Devices are not discovered during
 takeaway/giveback testing
Date: Sun, 24 May 2015 21:56:43 +0200
Message-ID: <20150524215643.00003055@localhost>
References: <555f405d.19aP4Ju4SItrRE4D%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:56108 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbbEXT4m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 May 2015 15:56:42 -0400
In-Reply-To: <555f405d.19aP4Ju4SItrRE4D%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> 
> Devices are not discovered during takeaway/giveback testing
> 
> When a remote nport changes it's DID, a new ndlp is used.

its

> However, we left the old ndlp state unchanged and still in
> a discovery state. The may stall discovery resulting in some

The?

> devices not being discovered.  Correct by swapping the state

two spaces

> of the 2 ndlp's when a DID swap is detected.

Sebastian
