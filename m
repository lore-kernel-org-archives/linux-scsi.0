From: boutcher@cs.umn.edu (Dave Boutcher)
Subject: [PATCH] ibmvscsi: correctly reenable CRQ
Date: Mon, 16 Oct 2006 10:19:11 -0500
Message-ID: <17715.41711.993381.110914@hound.rchland.ibm.com>
References: <20061013152250.19701.18521.sendpatchset@ltcml8p1.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.34.202]:64732 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S1422640AbWJPPaN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 11:30:13 -0400
In-Reply-To: <20061013152250.19701.18521.sendpatchset@ltcml8p1.rchland.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Santiago Leon <santil@us.ibm.com>

On Fri, 13 Oct 2006 10:22:50 -0500, Santiago Leon <santil@us.ibm.com> said:
> 
> From: Santiago Leon <santil@us.ibm.com>
> The "ibmvscsi: treat busy and error conditions separately" patch submitted by Dave Boutcher back in June incorrectly reenables the CRQ.  The broken logic causes the adapter to get disabled if the CRQ connection happens to close temporarily.  This patch "fixes that obviously wrong logic check" (Dave's words).  Please apply.
> 
> Signed-off-by: Santiago Leon <santil@us.ibm.com>
> Signed-off-by: David Boutcher <sleddog@us.ibm.com>
> ---
>  ibmvscsi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

James, on a related note, I have taken a new job within
IBM, so Santi will be the maintainer for ibmvscsi related
work.  Please accept his patches without my signoff from now
on.

Thanks,

Dave B
