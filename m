From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/11] iscsi bugfixes
Date: Tue, 25 Jul 2006 11:24:29 -0500
Message-ID: <44C645BD.3050901@cs.wisc.edu>
References: <1153774027.1040.31.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:31428 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932168AbWGYQXq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jul 2006 12:23:46 -0400
Received: from [192.168.0.7] (c-24-118-221-159.hsd1.mn.comcast.net [24.118.221.159])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k6PGNj91018087
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2006 11:23:45 -0500
In-Reply-To: <1153774027.1040.31.camel@madmax>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Oops, oh yeah James,

I forgot to add that the patches, if possible, should go into 2.6.18. We
finally have all the major data path bugs, we know about at least, fixed
with this patchset. The #2 patch, fixes a nasty bug we were hitting with
writes and SMP boxes.



Mike Christie wrote:
> The following patches fixes some regressions and bugs we have had since
> the driver was created. The bugs include:
> 
> 1. Sending the wrong error values to userspace.
> 2. r2t list problems. We should not hit the BUG_ONs anymore.
> 3. Many abort fixes including handling the case where the session drops
> in the middle of an abort or if a command finishes and then we get the
> status.
> 4. Fix iser oops during session recovery.
> 5. More memory reduction patches. We should not be able to negotiate for
> larger maxrecvdatalength values and not be limited by how much memory we
> can allocate.
> 6. Fix id leaks
> 7. Fix allocation from soft irq context bug.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

