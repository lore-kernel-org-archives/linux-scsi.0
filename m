From: Christoph Hellwig <hch@infradead.org>
Subject: Re: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Thu, 11 Aug 2005 17:40:03 +0100
Message-ID: <20050811164003.GB4351@infradead.org>
References: <1123771874.5062.13.camel@mulgrave> <OF8F47C8EA.7E82D4E6-ONC125705A.0053F6D2-C125705A.00567F16@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:54765 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751112AbVHKQkG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 12:40:06 -0400
Content-Disposition: inline
In-Reply-To: <OF8F47C8EA.7E82D4E6-ONC125705A.0053F6D2-C125705A.00567F16@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harald Seipp <SEIPP@de.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Aug 11, 2005 at 05:44:46PM +0200, Harald Seipp wrote:
> Thank you for your quick responses! It finally looks like the task I need
> to do - fully rescan all hosts for newly attached/changed devices - must
> include the logic to skip devices with mounted fs for 2.6.

Why do you want to rescan a full bus anyway?  What SCSI transport do you
want this for?  All transports where new targets can be hot-plugged should
be doing automatic scanning already.

