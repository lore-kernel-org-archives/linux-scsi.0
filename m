From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: Block Limits VPD page fixes
Date: Thu, 25 Mar 2010 17:29:16 -0400
Message-ID: <4BABD5AC.9040709@interlog.com>
References: <yq1k4t3hb9g.fsf@sermon.lab.mkp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:38071 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab0CYV3Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Mar 2010 17:29:25 -0400
In-Reply-To: <yq1k4t3hb9g.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
> Add a few clarifying comments in the B0 page function and allow the
> optimal transfer length field to be specified on the command line using
> opt_blks=N.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
