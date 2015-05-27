From: Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH RFC 1/2] cxlflash: Base support for IBM CXL Flash Adapter
Date: Wed, 27 May 2015 16:37:58 +1000
Message-ID: <1432708678.15474.32.camel@neuling.org>
References: <1430110220-13268-1-git-send-email-mrochs@linux.vnet.ibm.com>
	 <20150511090941.GD28820@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:33485 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbbE0Gh7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2015 02:37:59 -0400
In-Reply-To: <20150511090941.GD28820@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Christoph,

> On Sun, Apr 26, 2015 at 11:50:20PM -0500, Matthew R. Ochs wrote:
> > SCSI device driver to support filesystem access on the IBM CXL Flash adapter.
> 
> Please drop all the code related to your weird direct access ioctls
> from this patch.  Without that it looks mostly mergeable.

What's your issue with this?  Do you just not like direct access at all,
or the way it's been done?

The CAPI hardware allows devices to have direct access to userspace
memory via an MMU.  What this driver is doing is enabling this direct
access so the flash controller can share memory (like queues) directly
with userspace without the kernel overhead.

Mikey
