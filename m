From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Linux v2.5.47
Date: Wed, 13 Nov 2002 00:43:04 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021113004304.A1196@infradead.org>
References: <Pine.LNX.4.44.0211101944030.17742-100000@penguin.transmeta.com> <20021113002222.B323@infradead.org> <1037149432.10083.32.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1037149432.10083.32.camel@irongate.swansea.linux.org.uk>; from alan@lxorguk.ukuu.org.uk on Wed, Nov 13, 2002 at 01:03:52AM +0000
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@transmeta.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Wed, Nov 13, 2002 at 01:03:52AM +0000, Alan Cox wrote:
> Very very nice. One question - what are the rules for the
> scsi_remove_host callback with regards to a hotplug ? 

The general rule so far is:  don't do hotplug - scsi code, especially
list handling, is racy as hell.  I'm not sure whether we'll have it
properly locked down and refcounted by 2.6, it's a lot of work left.

