From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Merging mpt2sas/mpt3sas code base
Date: Tue, 9 Jun 2015 00:22:18 -0700
Message-ID: <20150609072218.GA1537@infradead.org>
References: <011bc20cffa52ae1a7aca1f74c0244d1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40305 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbbFIHWV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2015 03:22:21 -0400
Content-Disposition: inline
In-Reply-To: <011bc20cffa52ae1a7aca1f74c0244d1@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya Prakash <sathya.prakash@avagotech.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>

Hi Sathya,

please start your effort per your plans.  I don't think we'll need
separate binaries as we should be fine with a MODULE_ALIAS and
registering two misc devices.  But compared to the overall effort
that's a fairly minor descision which we can revisit while going ahead.

Keeping the user interfaces 100% backwards compatible should be the
first priority.
