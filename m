From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_debug: Thin provisioning support
Date: Thu, 29 Oct 2009 03:09:49 -0400
Message-ID: <20091029070949.GA22077@infradead.org>
References: <yq1d44o8piw.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38541 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562AbZJ2HJp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2009 03:09:45 -0400
Content-Disposition: inline
In-Reply-To: <yq1d44o8piw.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Oct 15, 2009 at 02:45:27PM -0400, Martin K. Petersen wrote:
> 
> This version fixes 64-bit modulo on 32-bit as well as inadvertent map
> updates when TP was disabled.


Just started testing this my fs discard support and I noticed that you
track the mapping state globally.  Given that scsi_debug supports
multiple devices that seems rather suboptimal.

