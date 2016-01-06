From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/4] scsi: cleanup ioctl headers and provide UAPI versions
Date: Wed, 06 Jan 2016 16:00:44 -0500
Message-ID: <yq1poxeifsz.fsf@sermon.lab.mkp.net>
References: <1443173264-4105-1-git-send-email-pbonzini@redhat.com>
	<5681C57A.8030200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5681C57A.8030200@redhat.com> (Paolo Bonzini's message of "Tue,
	29 Dec 2015 00:27:54 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, bart.vanassche@sandisk.com, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Paolo" == Paolo Bonzini <pbonzini@redhat.com> writes:

>> This is v3 of the series to provide an "official" sg.h header (and
>> scsi_ioctl.h too, though it's basically obsolete) together with the
>> other userspace API definitions.  The change from v2 to v3 is that
>> defaults for sg.c are not exported in include/uapi/linux/sg.c.

Paolo> What happened to these patches?...

They predate me being patch monkey. Please repost with any review tags
or acks you may have received.

-- 
Martin K. Petersen	Oracle Linux Engineering
