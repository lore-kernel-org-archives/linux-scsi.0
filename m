From: Mike Christie <mikenc@us.ibm.com>
Subject: DM Multipath
Date: Thu, 08 Jan 2004 16:31:15 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FFDF653.7050302@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:63695 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266313AbUAIAbv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2004 19:31:51 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, dm-devel@sistina.com

There has been a lot of mention about DM and MD on linux-scsi, and 
recently on dm-devel there has been mention of multipath, linux SCSI and 
error codes 
http://lists.sistina.com/pipermail/dm-devel/2004-January/000367.html.

Are the error types that should be used to indicate different types of 
failures to upper layers, like was briefly touched on in these threads:
http://marc.theaimsgroup.com/?l=linux-scsi&m=106942406431082&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=106005572704429&w=2 (under #2)
in the works?

Thanks,

Mike Christie
mikenc@us.ibm.com

