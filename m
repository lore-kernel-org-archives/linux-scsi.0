From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 9/18] megaraid_sas : Support for Avago's Single server
 High Availability product
Date: Mon, 11 May 2015 02:19:48 -0700
Message-ID: <20150511091948.GH28820@infradead.org>
References: <201504231104.t3NB4P3F030217@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33484 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbbEKJTs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2015 05:19:48 -0400
Content-Disposition: inline
In-Reply-To: <201504231104.t3NB4P3F030217@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, jbottomley@parallels.com, kashyap.desai@avagotech.com

Did you test this on non-x86?  It seems like the dmi functions are
properly stubbed out, but I'd really prefer an explicit statement that
it is known to work.

