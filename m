From: "Ravi Anand" <ravi.anand@qlogic.com>
Subject: RE: scsi bus-reset in qlogic causes system stall
Date: Wed, 22 Jan 2003 11:29:27 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3679966B84813344B908D418BA3F6A4AA84095@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Steven Dake <sdake@mvista.com>, devnetfs <devnetfs@yahoo.com>, linux-scsi@vger.kernel.org

Our development is going on which will include the following changes:

		-v2.5.x changes
		-no hacks or changes for non public kernel tree
		-lot of other clean ups,
		-re-orginzation of sources 
		- suggestions and bug fixes from the linux scsi community etc...

before the driver is officially submitted to be  merged in the v2.5.x tree.

regards
ravi


-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org]
Sent: Monday, January 20, 2003 11:53 PM
To: Ravi Anand
Cc: Christoph Hellwig; Steven Dake; devnetfs; linux-scsi@vger.kernel.org
Subject: Re: scsi bus-reset in qlogic causes system stall


On Mon, Jan 20, 2003 at 04:06:53PM -0800, Ravi Anand wrote:
> Added to take care some of the changes made by the VMWARE guys in the kernel.Included at the request from our OEM's.This will compile against the modified kernel from VMWARE.
> 
> Hope this answer your question.

OK.  Given the recent discussion about the qla2xxx driver in 2.5 I'd just
like to add that you shouldn't expect such ugly hacks for a non-public
kernel tree to ever get merged..

