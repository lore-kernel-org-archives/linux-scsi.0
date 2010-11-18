From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: Re: [PATCH 08/16] BNX2I: Added mutex lock protection to
 conn_get_param
Date: Thu, 18 Nov 2010 11:08:25 -0800
Message-ID: <1290107306.6191.110.camel@ltirv-waie-lx1>
References: <Eddie Wai <eddie.wai@broadcom.com>
 <1289430297-30221-9-git-send-email-eddie.wai@broadcom.com>
 <4CE49D31.7060104@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2577 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab0KRTGc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 14:06:32 -0500
In-Reply-To: <4CE49D31.7060104@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eddie Wai <waie@broadcom.com>, James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Benjamin Li <benli@broadcom.com>


On Wed, 2010-11-17 at 19:27 -0800, Mike Christie wrote:
> On 11/10/2010 05:04 PM, Eddie Wai wrote:
> > -		return iscsi_conn_get_param(cls_conn, param, buf);
> > +		len = iscsi_conn_get_param(cls_conn, param, buf);
> > +		if (len == -ENOSYS)
> > +			len = 0;
> 
> Why are you returning 0 here?
> 
Looks like returning -ENOSYS as-is is the expected behavior as cross
referenced to iscsi_tcp.  I'll remove this.  Thanks.  
> 


