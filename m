From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RESEND 6/18] megaraid_sas : Use Block layer tag support
 for internal command indexing
Date: Wed, 22 Apr 2015 04:40:02 -0700
Message-ID: <20150422114002.GA19903@infradead.org>
References: <201504201235.t3KCZWSY016519@palmhbs0.lsi.com>
 <20150421104210.GC8920@infradead.org>
 <3224b33c001a84f19fc033e0d55422a1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45690 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055AbbDVLkD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2015 07:40:03 -0400
Content-Disposition: inline
In-Reply-To: <3224b33c001a84f19fc033e0d55422a1@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>

On Wed, Apr 22, 2015 at 05:02:03PM +0530, Sumit Saxena wrote:
> Christoph,
> I have started rework for the patches. I will remove debug printks. Can
> you please let me know should I go for separate patch for change in
> calling convention return_cmd?

If it makes a huge difference for you feel free to keep it as-is and
document the rationale for it in the changelog.
