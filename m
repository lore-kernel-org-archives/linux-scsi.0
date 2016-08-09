From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V2] aacraid: Check size values after double-fetch from user
Date: Mon, 08 Aug 2016 21:35:15 -0400
Message-ID: <yq1shueu3l8.fsf@sermon.lab.mkp.net>
References: <20160805194410.7198-1-david.carroll@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160805194410.7198-1-david.carroll@microsemi.com> (Dave
	Carroll's message of "Fri, 5 Aug 2016 13:44:10 -0600")
Sender: stable-owner@vger.kernel.org
To: Dave Carroll <david.carroll@microsemi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, aacraid@microsemi.com, wpengfeinudt@gmail.com, scott.banesh@microsemi.com, Linux-SCSI <linux-scsi@vger.kernel.org>, Johannes Thumshurn <jthumshirn@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Dave" == Dave Carroll <david.carroll@microsemi.com> writes:

Dave> In aacraid's ioctl_send_fib() we do two fetches from userspace,
Dave> one the get the fib header's size and one for the fib
Dave> itself. Later we use the size field from the second fetch to
Dave> further process the fib. If for some reason the size from the
Dave> second fetch is different than from the first fix, we may
Dave> encounter an out-of- bounds access in aac_fib_send(). We also
Dave> check the sender size to insure it is not out of bounds. This was
Dave> reported in https://bugzilla.kernel.org/show_bug.cgi?id=116751 and
Dave> was assigned CVE- 2016-6480.

Applied to 4.8/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
