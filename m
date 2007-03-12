From: Jeff Garzik <jeff@garzik.org>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Mon, 12 Mar 2007 10:45:16 -0400
Message-ID: <45F5677C.40602@garzik.org>
References: <45F48809.2060908@emc.com> <20070312081851.GA14831@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070312081851.GA14831@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ric Wheeler <ric@emc.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> the occasional 2k sector SCSI MO device aswell.  It would be nice to
> get samples of large sector size ATA devices into the hands of developers
> to do real world testing of the whole stack.

"hands of developers" meaning you specifically?  :)

I've had a 512b-logical/1K-physical ATA test drive for a few months now, 
and another couple arrived today.

Hopefully people can parse what I've been posting, since I cannot give 
out raw numbers or data at this time.

Of course, with RMW drives that leave the 512-b logical interface 
untouched, I had expected that they would Just Work(tm) and that is 
pretty much what happened.

	Jeff


