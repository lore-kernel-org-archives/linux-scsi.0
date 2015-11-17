From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH, RESEND] qla2xxx: Fix rwlock recursion
Date: Tue, 17 Nov 2015 18:22:49 -0500
Message-ID: <yq18u5wtdme.fsf@sermon.lab.mkp.net>
References: <564A663B.606@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48092 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbbKQXXC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2015 18:23:02 -0500
In-Reply-To: <564A663B.606@sandisk.com> (Bart Van Assche's message of "Mon, 16
	Nov 2015 15:26:51 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart> This patch fixes the following kernel bug

Applied (4.4).

-- 
Martin K. Petersen	Oracle Linux Engineering
