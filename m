From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux v2.5.47
Date: 13 Nov 2002 01:03:52 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1037149432.10083.32.camel@irongate.swansea.linux.org.uk>
References: <Pine.LNX.4.44.0211101944030.17742-100000@penguin.transmeta.com>
	<20021113002222.B323@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021113002222.B323@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@transmeta.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Wed, 2002-11-13 at 00:22, Christoph Hellwig wrote:
> 	[do basic setup]
> 	sdev = scsi_register();
> 	[do more setup]
> 	return scsi_add_host();
> 
> Similarly a new routine, scsi_remove_host exist to call at the end
> of the remove routine.

Very very nice. One question - what are the rules for the
scsi_remove_host callback with regards to a hotplug ? 

