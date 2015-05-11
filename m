From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 1/2] cxlflash: Base support for IBM CXL Flash Adapter
Date: Mon, 11 May 2015 02:09:41 -0700
Message-ID: <20150511090941.GD28820@infradead.org>
References: <1430110220-13268-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39513 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbbEKJJm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2015 05:09:42 -0400
Content-Disposition: inline
In-Reply-To: <1430110220-13268-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, mikey@neuling.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On Sun, Apr 26, 2015 at 11:50:20PM -0500, Matthew R. Ochs wrote:
> SCSI device driver to support filesystem access on the IBM CXL Flash adapter.

Please drop all the code related to your weird direct access ioctls
from this patch.  Without that it looks mostly mergeable.
