From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [usb-storage] Re: iRiver H100 series and usb-storage issues
Date: Tue, 8 Jun 2004 10:01:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040608170116.GB4757@us.ibm.com>
References: <1086711004.3647.23.camel@patibmrh9> <1086711371.2106.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:8635 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S265222AbUFHRCD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2004 13:02:03 -0400
Content-Disposition: inline
In-Reply-To: <1086711371.2106.14.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Pat LaVarre <p.lavarre@ieee.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, usb-storage@lists.one-eyed-alien.net, Alan Stern <stern@rowland.harvard.edu>, Philippe Troin <phil@fifi.org>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> On Tue, 2004-06-08 at 11:10, Pat LaVarre wrote:
> > Is there an easy way to test whether an HBA implements underflow
> > correctly?
> 
> Only by looking at the source.  I think the aic7 drivers do (both old
> and current).

Another example of looking at the source is the qla2xxx driver
(drivers/scsi/qla2xxx/qla_isr.c near line 1088). In this driver it
will return DID_ERROR.


-andmike
--
Michael Anderson
andmike@us.ibm.com

