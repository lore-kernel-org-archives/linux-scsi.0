From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] make the SCSI mid-layer obey the device online flag
Date: Fri, 6 Jun 2003 17:51:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200306061751.48937.oliver@neukum.org>
References: <1054742495.1674.18.camel@mulgrave> <20030606073603.A13259@infradead.org> <1054912742.1778.25.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mail1.kontent.de ([81.88.34.36]:35531 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S261887AbTFFPih (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 11:38:37 -0400
In-Reply-To: <1054912742.1778.25.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>


> For the remove_host scenario, it would be convenient just to do
> nice/surprise ejections on all the devices (from user level) and then do
> the clean up when the hosts device count falls to zero.  That may imply
> some type of host->offline flag which disallows the addition of new scsi
> devices to the host.

There's no use in that distinction. The hard, _common_  case to be solved is
surprise ejection. If you have solved that you've solved everything else with
it. Keeping any distinction here just complicates things. It just blurrs the
issue.

	Regards
		Oliver


