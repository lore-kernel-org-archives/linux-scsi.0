From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH as470] Add a NOREPORTLUN blacklist flag
Date: Mon, 21 Feb 2005 17:07:51 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0502211703160.31863-100000@netrider.rowland.org>
References: <20050221064709.GA30205@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from netrider.rowland.org ([192.131.102.5]:57865 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S262147AbVBUWHw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 17:07:52 -0500
In-Reply-To: <20050221064709.GA30205@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Sergey Vlasov <vsu@altlinux.ru>, Samuel Colin <Samuel.Colin3@wanadoo.fr>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Sun, 20 Feb 2005, Matthew Dharm wrote:

> > Matt, it looks like the best way to solve this problem is to go back to
> > the old strategy of always setting the SCSI revision to 2 (no matter what
> > it might actually be), at least for Direct Access devices.  That would
> > suppress the REPORT_LUNS command.  Would we lose anything by doing this?
> 
> Besides the use of REPORT_LUNS on devices which actually support it?  I
> don't think so...

That doesn't sound like much of a loss, especially since these devices do
implement Get_Max_LUN.  Or if they don't, I can't believe they would
implement REPORT_LUNS either.

I'll send in a patch for this soon.

Alan Stern

