From: Christoph Hellwig <hch@infradead.org>
Subject: Re: About ARECA RAID driver for Linux i386/x86-64
Date: Sun, 6 Feb 2005 14:51:20 +0000
Message-ID: <20050206145120.GC834@infradead.org>
References: <001001c508d9$d97a17f0$9300a8c0@erich2003> <20050202180817.47db64c2.akpm@osdl.org> <1107425132.4278.99.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:23724 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261185AbVBFOvY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Feb 2005 09:51:24 -0500
Content-Disposition: inline
In-Reply-To: <1107425132.4278.99.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@osdl.org>, erich <erich@areca.com.tw>, linux-scsi@vger.kernel.org

On Thu, Feb 03, 2005 at 11:05:32AM +0100, Arjan van de Ven wrote:
> * needs to use list.h lists not open coded ones

the only list uses I saw in a quick scan were for internal queueing
which should go away.  (see the tmscsim driver in 2.6 on what to return
when the queue is full)

> * uses wrong locking for the scsi layer (eg ->done should be called  
>   without locks)

it's not really wrong but totally superflous, so yes, it should go away.

