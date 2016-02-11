From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND] bfa: deinline __bfa_trc() and __bfa_trc32()
Date: Thu, 11 Feb 2016 09:41:32 -0500
Message-ID: <yq1io1v5mxv.fsf@sermon.lab.mkp.net>
References: <1454618448-1381-1-git-send-email-dvlasenk@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454618448-1381-1-git-send-email-dvlasenk@redhat.com> (Denys
	Vlasenko's message of "Thu, 4 Feb 2016 21:40:48 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Fabian Frederick <fabf@skynet.be>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Christoph Hellwig <hch@lst.de>, Guenter Roeck <linux@roeck-us.net>, Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Denys" == Denys Vlasenko <dvlasenk@redhat.com> writes:

Denys> __bfa_trc() compiles to 115 bytes of machine code.  With this
Denys> .config: http://busybox.net/~vda/kernel_config there are 1494
Denys> calls of __bfa_trc().

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
