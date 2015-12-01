From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 1/5] arcmsr: fixed getting wrong configuration data
Date: Mon, 30 Nov 2015 19:17:43 -0500
Message-ID: <yq1egf7f2e0.fsf@sermon.lab.mkp.net>
References: <1448451362.4670.29.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448451362.4670.29.camel@Centos6.3-64> (Ching Huang's message of
	"Wed, 25 Nov 2015 19:36:02 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de, jthumshirn@suse.de, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

>>>>> "Ching" == Ching Huang <ching2048@areca.com.tw> writes:

Hello Ching,

I applied both your series to 4.5/scsi-queue.

In the future please run checkpatch before submitting. Warnings are OK
but in this case there were several things flagged as errors that I had
to fix up by hand.

Also make sure you tag with "Signed-off-by:". Your signoff was mistyped
in all the patches.

Thank you!
Martin

-- 
Martin K. Petersen	Oracle Linux Engineering
