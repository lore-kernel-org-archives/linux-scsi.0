From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SCSI Disk layer performance
Date: Thu, 29 Jan 2004 18:59:06 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040129185906.C11929@infradead.org>
References: <1074720667.19927.384.camel@localhost.lnxi.com> <20040122135703.A11283@infradead.org> <4010FF56.2060806@cri74.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:27142 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266263AbUA2S7I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2004 13:59:08 -0500
Content-Disposition: inline
In-Reply-To: <4010FF56.2060806@cri74.org>; from fabien@cri74.org on Fri, Jan 23, 2004 at 12:02:46PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Fabien Salvi <fabien@cri74.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Jan 23, 2004 at 12:02:46PM +0100, Fabien Salvi wrote:
> > What kernel tree do you use?  If you're looking for decent scsi
> > performance use linux 2.6 or the SuSE/RH vendor trees.  Stock Linux 2.4
> > is basically unusable for higher scsi loads in SMP enviroments.
> 
> Can you give more details about this ?
> 
> Instead of using vendor trees, is it possible to use specific and 
> validated patchs about this ?

It's rather hard as there's a lot of them and they depend on each other.
Doug Ledford sayd he's going to sort put it into the 2.4 BK repos
at linux-scsi.bkbits.net one day, you could monitor it.

