From: Andrew Morton <akpm@osdl.org>
Subject: Re: please revert [PATCH] s390: zfcp act enhancements
Date: Tue, 16 Nov 2004 01:01:30 -0800
Message-ID: <20041116010130.771b4619.akpm@osdl.org>
References: <20041116085333.GA2652@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:62654 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261942AbUKPJBv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 04:01:51 -0500
In-Reply-To: <20041116085333.GA2652@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: schwidefsky@de.ibm.com, linux390@de.ibm.com, linux-scsi@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:
>
> That cset is adding tons of not used intree exports to the zfcp driver,
> for an IBM module for an API (SNIA HBA API) that we as we as the scsi
> team have rejected.
> 
> If IBM wants to support a managment API for their FC adapter they should
> participate in the FC transport class development.
> 
> I also want to protest that IBM sends scsi LLDD updates not via
> linux-scsi *AGAIN*.

Seconded, frankly.

Looking at the changelog:

	zfcp host adapter changes:
	  - Add access control enhancements.
	  - Add event callbacks.

if it had also had

	  - Add zillions of symbol exports

then people might have taken a closer look, no?
