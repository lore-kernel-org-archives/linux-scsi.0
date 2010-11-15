From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] target: Kconfig fixes
Date: Mon, 15 Nov 2010 12:31:07 -0800
Message-ID: <1289853067.22107.111.camel@haakon2.linux-iscsi.org>
References: <20101115194315.GA23989@infradead.org>
	 <20101115122621.ea812a6c.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36451 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238Ab0KOUgU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2010 15:36:20 -0500
In-Reply-To: <20101115122621.ea812a6c.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Mon, 2010-11-15 at 12:26 -0800, Randy Dunlap wrote:
> On Mon, 15 Nov 2010 14:43:15 -0500 Christoph Hellwig wrote:
> 
> > Use the menuconfig verb for the main TARGET_CORE option to make it look
> > better in menuconfig, use a big if TARGET_CORE to get rid of a lot of
> > depends, use help instead of ---help---, shorten lines to be under 80
> > chars where applicable, convert options to bool instead of tristate
> > where they should be, and remove the discuraged default values for
> > all the options.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Yes, mostly looks good, with the small exception of a few spaces-for-indents
> that should be tabs.  (identified below)
> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> 

Thanks guys, commited w/ Randy's spaces-for-indents fixes as d04f491.

--nab


