From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [usb-storage] Re: iRiver H100 series and usb-storage issues
Date: 08 Jun 2004 11:16:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086711371.2106.14.camel@mulgrave>
References: <Pine.LNX.4.44L0.0406081019281.1222-100000@ida.rowland.org><1086
	709937.2105.8.camel@mulgrave>  <1086711004.3647.23.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:2459 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265255AbUFHQQy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jun 2004 12:16:54 -0400
In-Reply-To: <1086711004.3647.23.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, usb-storage@lists.one-eyed-alien.net, Alan Stern <stern@rowland.harvard.edu>, Philippe Troin <phil@fifi.org>

On Tue, 2004-06-08 at 11:10, Pat LaVarre wrote:
> Is there an easy way to test whether an HBA implements underflow
> correctly?

Only by looking at the source.  I think the aic7 drivers do (both old
and current).

> For example, to inject an underflow into ioctl SG_IO, trivially I ask
> for a one block read CDB to fill a two block buffer.

But, as I said, underflow is largely historical.  Modern SCSI drives
just don't produce an unexpected underflow for which they report GOOD
status (well, except for the variable length transfer commands, of
course).  Hence this feature has languished.

James


