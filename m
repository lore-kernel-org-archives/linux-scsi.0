From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
Subject: RE: [PATCH RESEND] bfa: deinline __bfa_trc() and __bfa_trc32()
Date: Thu, 11 Feb 2016 08:42:22 +0000
Message-ID: <CY1PR11MB0218E705FD1EA084E74BF23094A80@CY1PR11MB0218.namprd11.prod.outlook.com>
References: <1454618448-1381-1-git-send-email-dvlasenk@redhat.com>
 <yq1k2mca2zy.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0114.outbound.protection.outlook.com ([157.56.110.114]:18428
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753107AbcBKI5W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2016 03:57:22 -0500
In-Reply-To: <yq1k2mca2zy.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Denys Vlasenko <dvlasenk@redhat.com>
Cc: James Bottomley <JBottomley@Parallels.com>, Fabian Frederick <fabf@skynet.be>, Christoph Hellwig <hch@lst.de>, Guenter Roeck <linux@roeck-us.net>, Ben Hutchings <ben@decadent.org.uk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

You could remove the __bfa_trc32() routine

Thanks,
Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

-----Original Message-----
From: Martin K. Petersen [mailto:martin.petersen@oracle.com] 
Sent: 10 February 2016 22:59
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: James Bottomley <JBottomley@Parallels.com>; Fabian Frederick <fabf@skynet.be>; Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>; Christoph Hellwig <hch@lst.de>; Guenter Roeck <linux@roeck-us.net>; Ben Hutchings <ben@decadent.org.uk>; linux-kernel <linux-kernel@vger.kernel.org>; linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH RESEND] bfa: deinline __bfa_trc() and __bfa_trc32()

>>>>> "Denys" == Denys Vlasenko <dvlasenk@redhat.com> writes:

Denys> __bfa_trc32() is very similar, so it is uninlined too.  However, 
Denys> it appears to be unused, therefore this patch ifdefs it out.

Why don't we just drop it?

-- 
Martin K. Petersen	Oracle Linux Engineering
