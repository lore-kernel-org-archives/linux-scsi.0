From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] clean up some more tmscsim scan logic
Date: Fri, 20 Aug 2004 22:36:25 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0408202128060.5097@poirot.grange>
References: <20040817163323.GA16799@lst.de> <Pine.LNX.4.60.0408172136340.5224@poirot.grange>
 <20040819113327.GA21326@lst.de> <Pine.LNX.4.60.0408192300530.5248@poirot.grange>
 <412524BE.1030002@adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:7884 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S268775AbUHTWKl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 18:10:41 -0400
In-Reply-To: <412524BE.1030002@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Thu, 19 Aug 2004, Luben Tuikov wrote:

> The device server should send sense information when the task
> finishes with CHECK CONDITION status _with_ the same transaction.
> (SAM-3r13, 5.9.6, SPC-3r18, 4.5.1).  This used to be called
> "autosense" a couple of years back, but no more as it is now
> protocol.
>
> This has been off-loaded to LLDD when the device doesn't support
> it, so that SCSI Core is basically SAM.
>
> BTW, the state and task queue would most likely change between
> the time SCSI Core gets CHECK CONDITION (with no sense) until
> the time it issues REQUEST SENSE, to get the sense for _that_
> command which failed.  Thus we want LLDDs to emulate it for
> devices which do not support it, since it has better (closer)
> control of the device.

Thanks for the explanations, Luben! Sounds reasonable, and crystalises my 
suspicions and guesses into a solid medium:-)

Guennadi
---
Guennadi Liakhovetski

