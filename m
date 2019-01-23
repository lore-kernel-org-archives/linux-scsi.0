From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH v2 0/3] scsi: arcmsr: Fix suspend/resume of
 ACB_ADAPTER_TYPE_B part 2
Date: Wed, 23 Jan 2019 11:42:34 +0800
Message-ID: <1548214954.4412.16.camel@Centos6.3-64>
References: <1547779645.4532.9.camel@Centos6.3-64>
         <yq136pkm6x7.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq136pkm6x7.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 2019-01-22 at 21:41 -0500, Martin K. Petersen wrote:
> Ching,
> 
> > This patch series are against to mkp's 5.1/scsi-queue.
> 
> Applied to 5.1/scsi-queue. Thank you.
> 
> PS. Your file permissions are odd. I always have to change your diffs
> from 755 to 644 before applying.
> 
Thanks Martin and Dan's help.

The file permission problem also confused to me.
I used Evolution mail of CentOS 6.x to submit the patches.
The mail context format is Plain text, preformatted.
I inserted the diff text file to the mail, and diff file listing as below.

-rw-r--r--. 1 root root 1663 Jan 16 04:11 p1.txt

Don't know why and when it's permission changed from 644 to 755.
