From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: Strange code in revalidate_scsidisk
Date: Tue, 14 Sep 2004 15:51:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040914155148.57e1cc49@lembas.zaitcev.lan>
References: <20040914152022.5d47cae4@lembas.zaitcev.lan>
	<20040914233742.A13966@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:23010 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S266275AbUINWwI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 18:52:08 -0400
In-Reply-To: <20040914233742.A13966@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, dledford@redhat.com

On Tue, 14 Sep 2004 23:37:43 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Sep 14, 2004 at 03:20:22PM -0700, Pete Zaitcev wrote:

> > Here's a short summary to provide the context for my question. Fujitsu report
> > a lockup (on RHEL3, but the code is the same as 2.6). They hook up a USB
> 
> Actually the code looks completely different in 2.6.  And yes, the 2.4 code
> looks extremly fishy.

I must've changed to a wrong directory by accident. Sorry for the confusion.

-- Pete
