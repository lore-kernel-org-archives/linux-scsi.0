From: Anton Blanchard <anton@samba.org>
Subject: Re: When is QLogic 6.x driver going into 2.5?
Date: Thu, 2 Jan 2003 10:29:35 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030101232935.GA12395@krispykreme>
References: <3679966B84813344B908D418BA3F6A4AA8406B@AVEXCH01.qlogic.org> <20030101114756.A19957@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030101114756.A19957@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ravi Anand <ravi.anand@qlogic.com>, rwhron@earthlink.net, linux-scsi@vger.kernel.org


> > Can you kindly elaborate on the extra work needed.
> 
> First thing is of course to actually port the driver to 2.5-CURRENT, there's
> no way it'll get into 2.4 before 2.5.

Keep in mind that Matt Jacob's driver has been shown to work in recent 2.5
and also works on big endian 64 bit. 

I spent over a day trying to make the qlogic driver work on ppc64 and gave
up in despair. It was much harder to navigate the source.

Anton
