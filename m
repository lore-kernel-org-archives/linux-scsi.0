From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 2.6 aacraid: endian cleanup
Date: Tue, 29 Mar 2005 17:51:28 +0100
Message-ID: <20050329165128.GA30917@infradead.org>
References: <1111430484.9918.9.camel@markh1.pdx.osdl.net> <20050328215931.GB14148@infradead.org> <1112114974.16948.13.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:24234 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261232AbVC2Qvb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2005 11:51:31 -0500
Content-Disposition: inline
In-Reply-To: <1112114974.16948.13.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Tue, Mar 29, 2005 at 08:49:33AM -0800, Mark Haverkamp wrote:
> I ran sparse on the driver and without the -Wbitwise, it only has 7
> warnings such as:
> 
> CHECK   drivers/scsi/aacraid/linit.c
> drivers/scsi/aacraid/linit.c:218:12: warning: symbol 'aac_info' was not declared. Should it be static?
> 
> With -Wbitwise there are about 200 warnings of this sort:
> drivers/scsi/aacraid/aachba.c:180:18: warning: incorrect type in assignment (different base types)
> drivers/scsi/aacraid/aachba.c:180:18:    expected unsigned int [unsigned] [usertype] command
> drivers/scsi/aacraid/aachba.c:180:18:    got restricted unsigned int [usertype] [force] <noident>
> 
> What is your preference,  I could clean up the existing patch and re-
> submit and then address the sparse warnings with a follow-up patch.  Or
> try to fix everything in one patch.

I think we can postpone the sparse fixes to a followon patch.

