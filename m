From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch RESEND] atp870u: 64 bit bug in atp885_init()
Date: Wed, 9 Dec 2015 20:48:19 +0300
Message-ID: <20151209174819.GB5177@mwanda>
References: <55B9CA3B.1030205@suse.de>
 <20151209102453.GE3173@mwanda>
 <20151209115339.46a09d94@lxorguk.ukuu.org.uk>
 <20151209134512.GA5177@mwanda>
 <20151209141459.41a237c9@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50838 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbbLIRs5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2015 12:48:57 -0500
Content-Disposition: inline
In-Reply-To: <20151209141459.41a237c9@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Ondrej Zary <linux@rainbow-software.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Hannes Reinecke <hare@suse.com>

We should add a tag to indicate that we are sending a patch for a crappy
driver.

IMHO-this-driver-is-garbage: Your Name <email>

If it got 10 votes of no confidence it would be moved to staging and
then deleted.

Anyway, realistically, let's just apply this fix.  It's tempting to
think we could delete all atp885 related code, but maybe people are
still using it with 32 bit kernels.  Or someone could delete it, but I'm
not brave enough to be the one to do it.

regards,
dan carpenter
