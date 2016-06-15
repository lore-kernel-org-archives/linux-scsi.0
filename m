From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] 53c700: fix BUG on untagged commands
Date: Tue, 14 Jun 2016 22:03:58 -0400
Message-ID: <yq1oa73b435.fsf@sermon.lab.mkp.net>
References: <1465880407.18583.18.camel@linux.vnet.ibm.com>
	<20160614150555.GA698@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <20160614150555.GA698@infradead.org> (Christoph Hellwig's message
	of "Tue, 14 Jun 2016 08:05:55 -0700")
Sender: linux-parisc-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Parisc List <linux-parisc@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> But it should really go together with something like this:

I completely agree with your patch but it's more of a cleanup. I'll put
it in 4.8 once James' fix hits.

-- 
Martin K. Petersen	Oracle Linux Engineering
