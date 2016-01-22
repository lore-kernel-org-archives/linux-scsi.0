From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] iscsi: fix regression caused by session lock patch
Date: Fri, 22 Jan 2016 10:50:31 -0600
Message-ID: <56A25DD7.5090700@linux.vnet.ibm.com>
References: <1447304741-6594-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:49355 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbcAVQui (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2016 11:50:38 -0500
Received: from localhost
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 22 Jan 2016 09:50:38 -0700
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id ACF583E4005E
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jan 2016 09:50:36 -0700 (MST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u0MGoafX27721802
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jan 2016 16:50:36 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u0MGoYJ5014846
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jan 2016 11:50:34 -0500
In-Reply-To: <1447304741-6594-1-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mchristi@redhat.com, linux-scsi@vger.kernel.org
Cc: Guilherme Piccoli <gpiccoli@linux.vnet.ibm.com>

On 11/11/2015 11:05 PM, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> 
> This patch fixes this oops report by Guilherme Piccol:
> 
> list_del corruption. prev->next should be c000000f3da2b080, but was c000000f3da2c080

Hi Mike! I haven't seen any follow ups on this for a while. What is the plan for this one? 

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

