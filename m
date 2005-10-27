From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/8] qla4xxx: new driver -- request for review.
Date: Thu, 27 Oct 2005 18:37:34 -0500
Message-ID: <436164BE.7010500@cs.wisc.edu>
References: <200510271831.j9RIVL3S024752@falcon30.maxeymade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:9870 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932693AbVJ0Xh7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Oct 2005 19:37:59 -0400
In-Reply-To: <200510271831.j9RIVL3S024752@falcon30.maxeymade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@maxeymade.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Doug Maxey wrote:
> 
> Any new patches in the pipeline?  
> 
> Looking for volunteers?
> 

If you are looking for something to do, you could fix up 
scsi_transport_iscsi.c in scsi-misc so HW and software iscsi could use 
it. I told Andrew I would do it, but I have been swamped doing things 
like qla2xxx and mpt updates and multipath stuff at work so I have not 
gotton to do much iscsi stuff lately :)
