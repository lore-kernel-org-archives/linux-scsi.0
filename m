From: Christoph Hellwig <hch@infradead.org>
Subject: Re: LUN resizing
Date: Fri, 28 Nov 2003 10:23:55 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031128102355.A7564@infradead.org>
References: <1069708054.26088.127.camel@lt-sv> <1069774983.2061.28.camel@mulgrave> <1069776713.1787.36.camel@mulgrave> <1069839911.26091.443.camel@lt-sv> <20031126094804.A2717@infradead.org> <1069965713.886.38.camel@lt-sv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:2067 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262109AbTK1KX6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2003 05:23:58 -0500
Content-Disposition: inline
In-Reply-To: <1069965713.886.38.camel@lt-sv>; from Stefan.Voelkel@millenux.com on Fri, Nov 28, 2003 at 11:08:49AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Stefan Voelkel <Stefan.Voelkel@millenux.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Nov 28, 2003 at 11:08:49AM +0100, Stefan Voelkel wrote:
> > No way.  You're better of using a proper volume manager instead of doing
> > this paritioning mess.
> 
> True, let's forget about the partitions: mount /dev/sda /home. 

Indeed.  If you're resizing luns they're most likely virtualized
alreday anyway :)

