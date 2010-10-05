From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH]SCSI: don't return errors for failures in sd_suspend()
Date: Tue, 5 Oct 2010 17:10:57 +0200
Message-ID: <201010051710.57278.oneukum@suse.de>
References: <201010051628.21414.oneukum@suse.de> <1286289497.6661.8.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab0JEPJ6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Oct 2010 11:09:58 -0400
In-Reply-To: <1286289497.6661.8.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, hare@suse.de

Am Dienstag, 5. Oktober 2010, 16:38:17 schrieb James Bottomley:

> The most likely cause of error is cache sync failure so at the point of
> power off for suspend, we'll lose data.  This might not be an
> uncorrectable error either; it could be memory allocation failure or a
> host of other transient reasons.

OK, then I'll come up with something ultraconservative.

	Regards
		Oliver 
