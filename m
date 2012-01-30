From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v4 0/3] virtio-scsi driver
Date: Mon, 30 Jan 2012 09:48:43 +0100
Message-ID: <4F26596B.6030703@redhat.com>
References: <1327077939-7084-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41705 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab2A3Ist (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2012 03:48:49 -0500
In-Reply-To: <1327077939-7084-1-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>

On 01/20/2012 05:45 PM, Paolo Bonzini wrote:
> This is the first implementation of the virtio-scsi driver, a virtual
> HBA that will be supported by KVM.  It implements a subset of the spec,
> in particular it does not implement asynchronous notifications for either
> LUN reset/removal/addition or CD-ROM media events, but it is already
> functional and usable.
>
> Other matching bits:
>
> - spec at http://people.redhat.com/pbonzini/virtio-spec.pdf
>
> - QEMU implementation at git://github.com/bonzini/qemu.git,
>    branch virtio-scsi
>
> Please review.  I would like this to be included in 3.3, since the
> possibility of regressions is obviously zero.
>
> Paolo Bonzini (3):
>    virtio-scsi: first version
>    virtio-scsi: add error handling
>    virtio-scsi: add power management support
>
> v3->v4: renamed VIRTIO_SCSI_S_UNDERRUN to VIRTIO_SCSI_S_OVERRUN;
>      fixed 32-bit compilation; added power management support;
>      adjusted calls to virtqueue_add_buf
>
>   drivers/scsi/Kconfig        |    8 +
>   drivers/scsi/Makefile       |    1 +
>   drivers/scsi/virtio_scsi.c  |  594 +++++++++++++++++++++++++++++++++++++++++++
>   include/linux/virtio_ids.h  |    1 +
>   include/linux/virtio_scsi.h |  114 +++++++++
>   5 files changed, 718 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/scsi/virtio_scsi.c
>   create mode 100644 include/linux/virtio_scsi.h
>

Ping?

Paolo
