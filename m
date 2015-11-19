From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND_2] scsi_sysfs: protect against double execution of __scsi_remove_device()
Date: Thu, 19 Nov 2015 12:16:52 -0500
Message-ID: <yq1h9khoqnv.fsf@sermon.lab.mkp.net>
References: <1447938139-22072-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447938139-22072-1-git-send-email-vkuznets@redhat.com> (Vitaly
	Kuznetsov's message of "Thu, 19 Nov 2015 14:02:19 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Vitaly" == Vitaly Kuznetsov <vkuznets@redhat.com> writes:

Vitaly> On some host errors storvsc module tries to remove sdev by
Vitaly> scheduling a job which does the following:

Applied to 4.4.

-- 
Martin K. Petersen	Oracle Linux Engineering
