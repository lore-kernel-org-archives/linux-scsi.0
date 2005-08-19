From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Fri, 19 Aug 2005 14:07:05 -0400
Message-ID: <43061FC9.8060301@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A3A@xbl3.ma.emulex.com> <4304DBA1.4050900@pobox.com> <20050819140631.GB12485@lst.de> <43061C3C.2020303@adaptec.com> <20050819175459.GA16619@lst.de> <43061D57.9060201@adaptec.com> <20050819175929.GA5614@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:32427 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S965057AbVHSSHI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 14:07:08 -0400
In-Reply-To: <20050819175929.GA5614@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, James.Smart@Emulex.Com, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On 08/19/05 13:59, Christoph Hellwig wrote:
>>Which one is it that will let you do this?
> 
> Currently none.  Fusion is doing the SATA command translation in firmware.
> This is more for Adapters in the style of the Adaptec design where it
> would be done in the host software stack.

So you're doing architectural decisions based on guesses on how
Adaptec's (design) driver is?

Why not let Jeff worry about SATA stuff?

There is a lot more areas where SCSI core needs improvement --
*that* would be commendable work.

	Luben
