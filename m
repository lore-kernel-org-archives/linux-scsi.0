From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: virtio_scsi: don't send sc payload with tmfs
Date: Wed, 06 Mar 2019 12:35:54 -0500
Message-ID: <yq1tvgfzz0l.fsf@oracle.com>
References: <1550403730-27876-1-git-send-email-felipe@nutanix.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1550403730-27876-1-git-send-email-felipe@nutanix.com> (Felipe
        Franciosi's message of "Wed, 27 Feb 2019 16:10:34 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Felipe Franciosi <felipe@nutanix.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Felipe,

> The virtio scsi spec defines struct virtio_scsi_ctrl_tmf as a set of
> device-readable records and a single device-writable response entry:

Applied to 5.1/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
