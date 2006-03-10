From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 25/28] aacraid: fix the comparison with sizeof()
Date: Fri, 10 Mar 2006 16:42:42 +0000
Message-ID: <20060310164242.GC6397@infradead.org>
References: <200603080816.k288GUd4002250@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57292 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751840AbWCJQmp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 11:42:45 -0500
Content-Disposition: inline
In-Reply-To: <200603080816.k288GUd4002250@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, tiwai@suse.de

On Wed, Mar 08, 2006 at 12:14:41AM -0800, akpm@osdl.org wrote:
> 
> From: Takashi Iwai <tiwai@suse.de>
> 
> Fix the comparison with sizeof() in min() macro.

This should use min_t.  I'll send a patch shortly.

