From: Christoph Hellwig <hch@infradead.org>
Subject: Re: scsi bus-reset in qlogic causes system stall
Date: Mon, 20 Jan 2003 10:40:55 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030120104055.A25262@infradead.org>
References: <3679966B84813344B908D418BA3F6A4AA84088@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3679966B84813344B908D418BA3F6A4AA84088@AVEXCH01.qlogic.org>; from ravi.anand@qlogic.com on Fri, Jan 17, 2003 at 02:23:07PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Steven Dake <sdake@mvista.com>, devnetfs <devnetfs@yahoo.com>, linux-scsi@vger.kernel.org

On Fri, Jan 17, 2003 at 02:23:07PM -0800, Ravi Anand wrote:
> Please use the following link to download the latest driver-v6.04.00b8
> 
> http://www.qlogic.com/support/os_detail.asp?productid=125&osid=26

Could you explain all the junk this release added under
#ifdef __VMWARE__?  Especially a pointer to the ill kernel this is supposed to
compile against would be quite helpfull.

