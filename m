From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/22] FCoE VN2VN fixes
Date: Fri, 5 Aug 2016 09:43:18 +0200
Message-ID: <46f7c046-3ed7-d087-6fcf-2f92d8167fde@suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
 <3fbe8456-182a-d7da-068d-28866aef5314@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933811AbcHEHnU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2016 03:43:20 -0400
In-Reply-To: <3fbe8456-182a-d7da-068d-28866aef5314@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>

On 08/04/2016 04:59 PM, Bart Van Assche wrote:
> On 08/03/16 06:13, Hannes Reinecke wrote:
>> As usual, comments and reviews are welcome.
> 
> Great work :-) Have you been testing these patches against the LIO FCoE
> target driver? In that case you might need to port the following patch
> to LIO, a patch that fixes a subtle data corruption issue:
> https://sourceforge.net/p/scst/svn/4969.
> 
Indeed I have. With this patchset I've managed to run FCoE over virtio
with LIO running on the host. Quite cool, methinks :-)

And indeed, your patch seem to be helping with the issues I've seen
(mysterious out-of-order frames and wireshark complaining about invalid
frames).
Still a bit hackish, though. Can't we move the data destructor into the
skb itself and not free the data in the target core?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
