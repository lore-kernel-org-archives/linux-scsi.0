From: "Ravi Anand" <ravi.anand@qlogic.com>
Subject: RE: scsi bus-reset in qlogic causes system stall
Date: Mon, 20 Jan 2003 16:06:53 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3679966B84813344B908D418BA3F6A4AA8408E@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Steven Dake <sdake@mvista.com>, devnetfs <devnetfs@yahoo.com>, linux-scsi@vger.kernel.org

Added to take care some of the changes made by the VMWARE guys in the kernel.Included at the request from our OEM's.This will compile against the modified kernel from VMWARE.

Hope this answer your question.

Ravi

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org]
Sent: Monday, January 20, 2003 2:41 AM
To: Ravi Anand
Cc: Steven Dake; devnetfs; linux-scsi@vger.kernel.org
Subject: Re: scsi bus-reset in qlogic causes system stall


On Fri, Jan 17, 2003 at 02:23:07PM -0800, Ravi Anand wrote:
> Please use the following link to download the latest driver-v6.04.00b8
> 
> http://www.qlogic.com/support/os_detail.asp?productid=125&osid=26

Could you explain all the junk this release added under
#ifdef __VMWARE__?  Especially a pointer to the ill kernel this is supposed to
compile against would be quite helpfull.

