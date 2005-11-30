From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] aacraid: Fix default FIB size
Date: Wed, 30 Nov 2005 19:12:45 +0000
Message-ID: <20051130191245.GB19001@infradead.org>
References: <1133375766.2288.22.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:11714 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751532AbVK3TMq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 14:12:46 -0500
Content-Disposition: inline
In-Reply-To: <1133375766.2288.22.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Wed, Nov 30, 2005 at 10:36:06AM -0800, Mark Haverkamp wrote:
> Received from Mark Salyzyn.
> 
> If the adapter has not instructed us otherwise that it can handle a
> 'large' FIB, then it can handle at most a 2KB FIB.

this should probably go into 2.6.15

