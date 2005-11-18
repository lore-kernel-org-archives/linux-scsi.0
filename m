From: Brian King <brking@us.ibm.com>
Subject: Re: aic7xxx support for >2TB volumes?
Date: Fri, 18 Nov 2005 09:01:47 -0600
Message-ID: <437DECDB.3070509@us.ibm.com>
References: <200511161208.02374.kilian.cavalotti@lip6.fr> <437D97E9.8020709@torque.net> <200511181355.17911.kilian.cavalotti@lip6.fr>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:34440 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1750776AbVKRPBy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2005 10:01:54 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id jAIF1nYR013871
	for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2005 10:01:49 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id jAIF37LY074852
	for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2005 08:03:07 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id jAIF1mvZ024663
	for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2005 08:01:49 -0700
In-Reply-To: <200511181355.17911.kilian.cavalotti@lip6.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kilian CAVALOTTI <kilian.cavalotti@lip6.fr>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

Kilian CAVALOTTI wrote:

> What I can't really understand is how a device could fail on a READ CAPACITY 
> 16 if plugged on an HBA, but work if plugged on another one... 

Looks to me like the aic7xxx driver does not change max_cmd_len from
the default of 12, so any 16 byte cdb gets failed back by scsi core.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
