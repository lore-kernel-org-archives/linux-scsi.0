From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Very slow throughput when using cdparanoia on two SATA CDROM
 drives with /dev/sr but not /dev/sg
Date: Wed, 19 Nov 2014 22:34:20 -0800
Message-ID: <20141120063420.GA18238@infradead.org>
References: <545B76B2.1020906@buttersideup.com>
 <20141107213723.GA5088@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43103 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaKTGeb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 01:34:31 -0500
Content-Disposition: inline
In-Reply-To: <20141107213723.GA5088@animx.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: Tim Small <tim@buttersideup.com>, linux-scsi@vger.kernel.org

Wakko, any chance you could resend a patch to remove the mutex from the
ioctl path?

