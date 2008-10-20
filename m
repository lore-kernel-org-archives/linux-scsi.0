From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Problems with new block device size reporting
Date: Mon, 20 Oct 2008 18:08:45 -0400
Message-ID: <1224540525.3586.26.camel@localhost.localdomain>
References: <3F0757B4-6310-4EB7-9E2B-C51101BCC41A@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33903 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbYJTWIu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2008 18:08:50 -0400
In-Reply-To: <3F0757B4-6310-4EB7-9E2B-C51101BCC41A@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chuck Lever <chuck.lever@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2008-10-20 at 17:58 -0400, Chuck Lever wrote:
> [ Cc'ing myself because I'm not subscribed to linux-scsi ]
> 
> Hi James-
> 
> I found two problems in 2.6.27:
> 
> 1.  If CONFIG_LBD is not set on 32-bit platforms, the computation  
> added in sd_read_capacity() by commit 7404ad3b computes sz  
> incorrectly.  On my system (a Fedora 9 VMware guest with an 8GB disk),  
> sz is computed as zero.
> 
> 2.  The new string helper string_get_size() added by commit 3c9f3681  
> goes into an infinite loop if it is passed a "size" of zero.  the "for  
> (j=0;" loop never terminates because 0*10 is always less than 1000.

Actually, both reported with patches:

http://marc.info/?l=linux-scsi&m=122400928411030
http://marc.info/?l=linux-scsi&m=122400928511033

James


