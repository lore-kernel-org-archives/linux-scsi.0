From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [patch 0/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 09:30:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41596793.6040900@adaptec.com>
References: <4159611C.4030106@adaptec.com> <20040928141228.A1815@infradead.org> <415964D2.80808@adaptec.com> <20040928142133.A1956@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:18647 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267799AbUI1NbI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:31:08 -0400
In-Reply-To: <20040928142133.A1956@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Christoph Hellwig wrote:
> On Tue, Sep 28, 2004 at 09:19:14AM -0400, Luben Tuikov wrote:
> 
>>True -- I just needed a base so as to be able to "link"
>>the rest of the patches from our SCM.
>>
>>The "final" version has all the dependencies right.
> 
> 
> Then please don't bother us with the intermediate versions. Diff the
> current scsi-misc tree (which is ahead of mainline) vs your final version
> and split the patch into logical pieces.

Hm, ok, you're the first one to mention doing it like this.
 From our previous emails I thought you wanted to see
a gradual progression.

BTW, I've never tried generating such a patch -- not sure
what would it look like and/or if it would be possible to
subdivide it into logical pieces.

	Luben




