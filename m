From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Adding PCI ID tables to aic7xxx and aic79xxx
Date: Tue, 12 Oct 2004 19:14:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041012181452.GA23536@infradead.org>
References: <416C15E5.7030805@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:4613 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267483AbUJLSO5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Oct 2004 14:14:57 -0400
Content-Disposition: inline
In-Reply-To: <416C15E5.7030805@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

Any chance you could 

 a) use normal constanst instead of taking apart the "wrong" (aka FreeBSDish)
    constants and put them back together
 b) remove the double-matching

aka try to hack something like my last two untested patches.  While the this
patch is a functional improvement over what we have it's still totally
obsfucated.
