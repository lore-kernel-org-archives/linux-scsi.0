From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH as470] Add a NOREPORTLUN blacklist flag
Date: Mon, 28 Feb 2005 19:26:42 +0200
Message-ID: <1109611602.5330.4.camel@mulgrave>
References: <Pine.LNX.4.44L0.0502202236350.9805-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:7099 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261753AbVB1V3j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2005 16:29:39 -0500
In-Reply-To: <Pine.LNX.4.44L0.0502202236350.9805-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sergey Vlasov <vsu@altlinux.ru>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Samuel Colin <Samuel.Colin3@wanadoo.fr>, SCSI Mailing List <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Sun, 2005-02-20 at 22:44 -0500, Alan Stern wrote:
> James, please withdraw the patch above.

Actually, I already have this in the tree.  Could you just do an
incremental to remove the blacklist line since I think the IBM people
still want their shark fix?

Thanks,

James


