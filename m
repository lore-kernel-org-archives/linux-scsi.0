From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] fix 2.5 scsi queue depth setting
Date: Wed, 6 Nov 2002 10:39:20 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021106103920.A12204@eng2.beaverton.ibm.com>
References: <patmans@us.ibm.com> <200211061832.gA6IWgb03420@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200211061832.gA6IWgb03420@localhost.localdomain>; from James.Bottomley@steeleye.com on Wed, Nov 06, 2002 at 01:32:42PM -0500
List-Id: linux-scsi@vger.kernel.org
To: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Wed, Nov 06, 2002 at 01:32:42PM -0500, J.E.J. Bottomley wrote:
> patmans@us.ibm.com said:
> 
> OK, missed that.  What about just conditioning the call to 
> scsi_adjust_queue_depth to be if you don't have a slave attach call.  The 
> expectation would be that if you do have a slave_attach then the queue depth 
> stays one until something is done about it by the LLD?
> 
> James
> 

That is what we had before, but then there is no warning that the
queue depth is at 1, and the only way to make sure it is right is to
audit the drivers.

-- Patrick Mansfield
