From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] aacraid 32/64 ioctl support (update)
Date: Wed, 16 Jun 2004 10:52:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040616105231.74bb78c9.davem@redhat.com>
References: <1087401137.13488.61.camel@markh1.pdx.osdl.net>
	<20040616160107.GA14144@infradead.org>
	<20040616160232.GB14144@infradead.org>
	<1087405920.13488.82.camel@markh1.pdx.osdl.net>
	<20040616171924.GA15925@infradead.org>
	<1087408316.13488.93.camel@markh1.pdx.osdl.net>
	<20040616175325.GA16751@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:951 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S264371AbUFPR6v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 13:58:51 -0400
In-Reply-To: <20040616175325.GA16751@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: markh@osdl.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, mark_salyzyn@adaptec.com, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 16 Jun 2004 18:53:25 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> > I just noticed this.  Can we use memset on a user pointer?  If not, what
> > would be the best way to handle this?
> 
> 
> Good question.  Maybe the architecture-folks know an answer?

Use clear_user()

