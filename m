From: Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH] scsi/ibmvscsi: add module alias for ibmvscsic
Date: Mon, 30 Jul 2012 21:06:06 +0200
Message-ID: <20120730190606.GD3155@aepfle.de>
References: <1342630158-16510-1-git-send-email-olaf@aepfle.de>
 <1343611946.21647.23.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:59854 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2G3TGK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2012 15:06:10 -0400
Content-Disposition: inline
In-Reply-To: <1343611946.21647.23.camel@pasglop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brian J King <bjking1@us.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org

On Mon, Jul 30, Benjamin Herrenschmidt wrote:

> On Wed, 2012-07-18 at 18:49 +0200, olaf@aepfle.de wrote:
> > From: Olaf Hering <olaf@aepfle.de>
> > 
> > The driver is named ibmvscsic, at runtime it its name is advertised as
> > ibmvscsi. For this reason mkinitrd wont pickup the driver properly.
> > Reported by IBM during SLES11 beta testing:
> > 
> > https://bugzilla.novell.com/show_bug.cgi?id=459933
> > LTC50724
> 
> So while this would work, I do wonder however whether we could instead
> fix it by simplifying the whole thing as follow since iSeries is now
> gone and so we don't need split backends anymore:
> 
> scsi/ibmvscsi: Remove backend abstraction

I cant that these things myself anymore.

Olaf
