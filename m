From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass larger
 receive buffer
Date: Thu, 13 Nov 2003 17:03:50 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0311131702560.949-100000@ida.rowland.org>
References: <1068751832.16444.78.camel@patrh9>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:59140 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264437AbTKMWDu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 17:03:50 -0500
In-Reply-To: <1068751832.16444.78.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: mdharm-scsi@one-eyed-alien.net, patmans@us.ibm.com, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

On 13 Nov 2003, Pat LaVarre wrote:

> Anybody able to clue me in quickly as to why classifying a device as
> writable or not, rather than a disc, can ever be meaningful?

The notion makes sense for tape drives as well.

Alan Stern

