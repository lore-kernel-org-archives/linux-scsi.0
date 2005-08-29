From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC] SCSI EH document
Date: Mon, 29 Aug 2005 15:49:41 -0400
Message-ID: <431366D5.5040605@pobox.com>
References: <20050826035326.GA13392@htj.dyndns.org> <430F8AE0.7080806@pobox.com> <4312D213.9000402@gmail.com> <431358FB.6050005@pobox.com> <20050829194954.GH26314@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:38082 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751478AbVH2Tt6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 15:49:58 -0400
In-Reply-To: <20050829194954.GH26314@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Tejun Heo <htejun@gmail.com>, James.Bottomley@steeleye.com, luben_tuikov@adaptec.com, albertcc@tw.ibm.com, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Mon, Aug 29, 2005 at 02:50:35PM -0400, Jeff Garzik wrote:
> 
>>Every node is a list_head.  You want all pointers for all nodes pointing 
>>to something useful, even if they are not actively present on a list, so 
>>that they may be easily and corrected added to a list at a later time. 
>>Read list_del_init() for example.
> 
> 
> I disagree.  If you know what you're doing, it's perfectly fine to
> simply list_del and not init the nodes.


True, but in the context of $thread its better to be safe than sorry.

	Jeff


