From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 2/2] sd: WRITE SAME(16) / UNMAP support
Date: Fri, 30 Oct 2009 00:28:38 -0400
Message-ID: <4AEA6B76.2010303@interlog.com>
References: <1256873409-12668-1-git-send-email-martin.petersen@oracle.com> <1256873409-12668-3-git-send-email-martin.petersen@oracle.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:45121 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbZJ3E2i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2009 00:28:38 -0400
In-Reply-To: <1256873409-12668-3-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: hch@infradead.org, axboe@kernel.dk, matthew@wil.cx, linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
> Implement a prepare discard function that sends either WRITE SAME(16) or
> UNMAP(10) depending on parameters indicated by the device in the block
> limits VPD.

And if both are supported by the logical unit, the patch
prefers UNMAP?

Doug Gilbert
