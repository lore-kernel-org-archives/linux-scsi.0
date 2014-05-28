From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [ANNOUNCE] scsi patch queue tree
Date: Wed, 28 May 2014 10:37:31 -0500
Message-ID: <538602BB.2080609@cs.wisc.edu>
References: <20140519140614.GA12183@infradead.org> <20140520100343.31490551@canb.auug.org.au> <20140520053928.GA1751@infradead.org> <20140521094636.515289e8@canb.auug.org.au> <1400639101.2481.19.camel@dabdike> <20140528105429.GA20549@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140528105429.GA20549@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/28/2014 05:54 AM, Christoph Hellwig wrote:
>       be2iscsi: Fix processing cqe for cxn whose endpoint is freed

I didn't look at your tree, but when this patch was posted on the list I
think it had a bug.

http://www.spinics.net/lists/linux-scsi/msg74191.html
