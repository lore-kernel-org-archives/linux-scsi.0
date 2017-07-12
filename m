From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] virtio_scsi: always read VPD pages for multiqueue too
Date: Wed, 12 Jul 2017 17:16:45 -0400
Message-ID: <yq1eftll5j6.fsf@oracle.com>
References: <1499243456-29978-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499243456-29978-1-git-send-email-pbonzini@redhat.com> (Paolo
        Bonzini's message of "Wed, 5 Jul 2017 10:30:56 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, stefanha@redhat.com, famz@redhat.com, stable@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
List-Id: linux-scsi@vger.kernel.org


Paolo,

> Multi-queue virtio-scsi uses a different scsi_host_template struct.
> Add the .device_alloc field there, too.

Applied to 4.13/scsi-fixes by hand. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
