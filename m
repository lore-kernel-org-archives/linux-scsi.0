From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fc transport: Add support for events
Date: Wed, 22 Feb 2006 17:45:33 +0000
Message-ID: <20060222174533.GA20794@infradead.org>
References: <43FC8CB4.2000507@emulex.com> <20060222172127.GA20137@infradead.org> <43FCA2CF.6080903@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:11465 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750708AbWBVRph (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 12:45:37 -0500
Content-Disposition: inline
In-Reply-To: <43FCA2CF.6080903@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Feb 22, 2006 at 12:43:43PM -0500, James Smart wrote:
> It would have been nice to have had this response on the RFC.
> 
> I'm actually looking into netlink for the CT pass thru, ELS and rnid
> functions.
> 
> Does it make sense to move forward with some event support - namely
> the events attributes minus the kobject_uevent() stuff ?

Actually the events attributes are what I don't like at all.  kobject_uevent
already is a wrapper around netlink, it just doesn't allow to transport
all the nessecary data.

