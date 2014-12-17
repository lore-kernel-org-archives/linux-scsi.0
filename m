From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Integrated Unit Attention handling
Date: Wed, 17 Dec 2014 12:54:06 +0100
Message-ID: <54916EDE.3000004@acm.org>
References: <548EFB97.2080501@suse.de> <20141216083245.GA29219@infradead.org> <5490501A.2020706@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:50907 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaLQLyQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Dec 2014 06:54:16 -0500
In-Reply-To: <5490501A.2020706@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>

On 12/16/14 16:30, Hannes Reinecke wrote:
> On 12/16/2014 09:32 AM, Christoph Hellwig wrote:
>> Sounds like a good topic, altough I hope we'll see considerable
>> progress before LSF on this item..
>
> Full integration requires a change of the SCSI device model;
> currently struct scsi_device has a fixed type and inquiry data, so
> rescan is essentially a no-op.
> So the current model requires the complete removal of the device and
> a rescan on the host.
> Doing that from within the SCSI stack will open quite some
> interesting race conditions, let alone interesting userspace
> interactions.
> Alternatively we can change the model to allow for a change of the
> inquiry data, but that should be discussed.
> 
> And then there is the Power-On/Reset handling, which probably would
> warrant a discussion on its own ...

Hello Hannes and Christoph,

If any of the topics raised by Hannes have not been resolved before the
LSF/MM starts I'm definitely interested in attending this discussion.

Bart.
