From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND] bfa: deinline __bfa_trc() and __bfa_trc32()
Date: Wed, 10 Feb 2016 12:28:49 -0500
Message-ID: <yq1k2mca2zy.fsf@sermon.lab.mkp.net>
References: <1454618448-1381-1-git-send-email-dvlasenk@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454618448-1381-1-git-send-email-dvlasenk@redhat.com> (Denys
	Vlasenko's message of "Thu, 4 Feb 2016 21:40:48 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: James Bottomley <JBottomley@Parallels.com>, Fabian Frederick <fabf@skynet.be>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Christoph Hellwig <hch@lst.de>, Guenter Roeck <linux@roeck-us.net>, Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Denys" == Denys Vlasenko <dvlasenk@redhat.com> writes:

Denys> __bfa_trc32() is very similar, so it is uninlined too.  However,
Denys> it appears to be unused, therefore this patch ifdefs it out.

Why don't we just drop it?

-- 
Martin K. Petersen	Oracle Linux Engineering
