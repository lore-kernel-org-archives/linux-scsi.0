From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 15/15] megaraid_sas: SPERC boot driver reorder
Date: Fri, 18 Dec 2015 06:05:10 -0800
Message-ID: <20151218140510.GA6679@infradead.org>
References: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
 <1450445228-26571-16-git-send-email-Sumit.Saxena@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37155 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbbLROFN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2015 09:05:13 -0500
Content-Disposition: inline
In-Reply-To: <1450445228-26571-16-git-send-email-Sumit.Saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>
Cc: jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, Uday Lingala <uday.lingala@avagotech.com>

On Fri, Dec 18, 2015 at 06:57:08PM +0530, Sumit Saxena wrote:
> This patch will add support for drive ordering for a particular set of device ID (0x005D, 0x005F) & subsystem vendor ID(0x1028). 

This really has no business in Linux.  Everyone should be using uuid
based disk addressing if they care.  Tell Dell they should stop coming
up with this crap, as they keep leaking this weird ordering things in
again and again.
