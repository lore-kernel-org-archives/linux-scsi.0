From: Christoph Hellwig <hch@infradead.org>
Subject: Re: scsi bus-reset in qlogic causes system stall
Date: Tue, 21 Jan 2003 07:52:51 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030121075251.A20853@infradead.org>
References: <3679966B84813344B908D418BA3F6A4AA8408E@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3679966B84813344B908D418BA3F6A4AA8408E@AVEXCH01.qlogic.org>; from ravi.anand@qlogic.com on Mon, Jan 20, 2003 at 04:06:53PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Christoph Hellwig <hch@infradead.org>, Steven Dake <sdake@mvista.com>, devnetfs <devnetfs@yahoo.com>, linux-scsi@vger.kernel.org

On Mon, Jan 20, 2003 at 04:06:53PM -0800, Ravi Anand wrote:
> Added to take care some of the changes made by the VMWARE guys in the kernel.Included at the request from our OEM's.This will compile against the modified kernel from VMWARE.
> 
> Hope this answer your question.

OK.  Given the recent discussion about the qla2xxx driver in 2.5 I'd just
like to add that you shouldn't expect such ugly hacks for a non-public
kernel tree to ever get merged..

