From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 0/2] clean up scsi documentation
Date: Mon, 11 Nov 2002 10:58:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211111558.gABFwsh17828@localhost.localdomain>
References: <eike@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA08322
	for <linux-scsi@vger.kernel.org>; Mon, 11 Nov 2002 07:58:57 -0800
In-Reply-To: Message from Rolf Eike Beer <eike@bilbo.math.uni-mannheim.de>
   of "Mon, 11 Nov 2002 16:50:06 +0100." <200211111650.06462@bilbo.math.uni-mannheim.de>
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike@bilbo.math.uni-mannheim.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

eike@bilbo.math.uni-mannheim.de said:
> Ok. What would be the best way of doing this? Move the files one by
> one? One  patch per file? Or a better script? 

I've already converted this to a BK script and applied it.

Except for the removal of ChangeLog.serverraid (I renamed this ChangeLog.ips).

James


