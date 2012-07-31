From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] scsi/ibmvscsi: add module alias for ibmvscsic
Date: Tue, 31 Jul 2012 13:08:42 +1000
Message-ID: <1343704122.8227.3.camel@pasglop>
References: <1342630158-16510-1-git-send-email-olaf@aepfle.de>
	 <1343611946.21647.23.camel@pasglop> <20120730190606.GD3155@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:59374 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab2GaDI5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jul 2012 23:08:57 -0400
In-Reply-To: <20120730190606.GD3155@aepfle.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian J King <bjking1@us.ibm.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, Olaf Hering <olaf@aepfle.de>

On Mon, 2012-07-30 at 21:06 +0200, Olaf Hering wrote:
> > So while this would work, I do wonder however whether we could
> instead
> > fix it by simplifying the whole thing as follow since iSeries is now
> > gone and so we don't need split backends anymore:
> > 
> > scsi/ibmvscsi: Remove backend abstraction
> 
> I cant that these things myself anymore.

Brian, can somebody from your side own these ?

Cheers,
Ben.


