From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 2/2] Use mutex_lock_timeout in qla2xxx driver
Date: Mon, 20 Nov 2006 13:21:33 -0800
Message-ID: <20061120212133.GJ11420@andrew-vasquezs-computer.local>
References: <20061109182721.GN16952@parisc-linux.org> <20061109183054.GO16952@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:24447 "EHLO
	avexch1.qlogic.com") by vger.kernel.org with ESMTP id S966784AbWKTVVg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Nov 2006 16:21:36 -0500
Content-Disposition: inline
In-Reply-To: <20061109183054.GO16952@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-driver@qlogic.com, hch@infradead.org

On Thu, 09 Nov 2006, Matthew Wilcox wrote:

> qla2xxx can use a mutex instead of a semaphore for mailbox serialisation.
> It can also use the new mutex_down_timeout function I introduced in
> patch 1/2.
> 
> Compile-tested only (I don't have a qlogic card conveniently available
> right now).
> 
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Initial testing appears promising.

Ack-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
