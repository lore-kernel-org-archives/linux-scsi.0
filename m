From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Strange code in revalidate_scsidisk
Date: Tue, 14 Sep 2004 23:37:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040914233742.A13966@infradead.org>
References: <20040914152022.5d47cae4@lembas.zaitcev.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:31755 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S269553AbUINWho (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 18:37:44 -0400
Content-Disposition: inline
In-Reply-To: <20040914152022.5d47cae4@lembas.zaitcev.lan>; from zaitcev@redhat.com on Tue, Sep 14, 2004 at 03:20:22PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-scsi@vger.kernel.org, dledford@redhat.com

On Tue, Sep 14, 2004 at 03:20:22PM -0700, Pete Zaitcev wrote:
> Hi, Guys:
> 
> Here's a short summary to provide the context for my question. Fujitsu report
> a lockup (on RHEL3, but the code is the same as 2.6). They hook up a USB

Actually the code looks completely different in 2.6.  And yes, the 2.4 code
looks extremly fishy.

