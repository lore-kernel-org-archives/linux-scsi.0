From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b7).
Date: Thu, 8 Jan 2004 11:33:36 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040108193336.GB10243@beaverton.ibm.com>
References: <B179AE41C1147041AA1121F44614F0B060EDD4@AVEXCH02.qlogic.org> <20040108165414.A12233@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:25337 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S265690AbUAHT3i
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2004 14:29:38 -0500
Content-Disposition: inline
In-Reply-To: <20040108165414.A12233@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@SteelEye.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>

Christoph Hellwig [hch@infradead.org] wrote:
> the SNIA HBA-API spec is completely broken.  But we should try to support
> a sanitized subset of the spec using the transport class work that's
> currently discussed on linux-scsi.
> 

This sounds good. It would seem that HBA API adapter and port
information through sysfs (libsysfs) should be doable through the
transport class.  Also some partial information of the other hba api
functions could be supported though other sysfs attributes but the sends
would still need to use the old interface.

-andmike
--
Michael Anderson
andmike@us.ibm.com

