From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_debug: Thin provisioning support
Date: Thu, 29 Oct 2009 22:33:56 -0400
Message-ID: <yq1tyxhtxt7.fsf@sermon.lab.mkp.net>
References: <yq1d44o8piw.fsf@sermon.lab.mkp.net>
	<20091029070949.GA22077@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:37208 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756986AbZJ3Cfy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2009 22:35:54 -0400
In-Reply-To: <20091029070949.GA22077@infradead.org> (Christoph Hellwig's
	message of "Thu, 29 Oct 2009 03:09:49 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> Just started testing this my fs discard support and I noticed
Christoph> that you track the mapping state globally.  Given that
Christoph> scsi_debug supports multiple devices that seems rather
Christoph> suboptimal.

Well, that's how scsi_debug works -- the devices all use the same
buffer.  Having a per-device backing store is on my todo list.

-- 
Martin K. Petersen	Oracle Linux Engineering
