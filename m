From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] megaraid_sas : Code optimization and refactoring
Date: Mon, 13 Apr 2015 22:56:40 -0700
Message-ID: <20150414055640.GA29338@infradead.org>
References: <201503271156.t2RBum1Y032249@palmhbs0.lsi.com>
 <yq11tjvil9g.fsf@sermon.lab.mkp.net>
 <bc4eb5dffe342f41aa5e9dba5afe3d95@mail.gmail.com>
 <yq17ftf7bko.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49163 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbbDNF4n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2015 01:56:43 -0400
Content-Disposition: inline
In-Reply-To: <yq17ftf7bko.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sumit Saxena <sumit.saxena@avagotech.com>, linux-scsi@vger.kernel.org, thenzl@redhat.com, hch@infradead.org, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>

On Mon, Apr 13, 2015 at 09:17:27PM -0400, Martin K. Petersen wrote:
> >>>>> "Sumit" == Sumit Saxena <sumit.saxena@avagotech.com> writes:
> 
> Sumit> Ok, I will spilt this patch in 7 patches. Do you have any
> Sumit> feedback/comments for other patches of this series? IF you are ok
> Sumit> with other patches, I will resend the series with patch#1
> Sumit> splitted in 7 patches and rest of the patches(2,3,4 and 5) will
> Sumit> remain unchanged.
> 
> The other patches looked OK on their own. But it's probably best to
> repost the whole series since you'll need a review from at least one
> person other than me.

Please also include the sparse fixes I sent you a while ago in the
repost.
