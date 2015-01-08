From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] megaraid_sas : Reserve commands for IOCTLs and
 internal DCMDs
Date: Thu, 8 Jan 2015 02:40:43 -0800
Message-ID: <20150108104043.GB600@infradead.org>
References: <201501051440.t05EeP9Q030054@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38062 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbbAHKkn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2015 05:40:43 -0500
Content-Disposition: inline
In-Reply-To: <201501051440.t05EeP9Q030054@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

Btw, what happend to the plan of using block layer host wide tags?
