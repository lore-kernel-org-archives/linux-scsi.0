From: Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH v4 0/3] virtio-scsi driver
Date: Wed, 1 Feb 2012 09:31:12 +0200
Message-ID: <CAOJsxLHwT0o=mS2nCSxjtwdfOif7oZkT_ZED3UOybFACVG6WvQ@mail.gmail.com>
References: <1327077939-7084-1-git-send-email-pbonzini@redhat.com>
	<4F26596B.6030703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F26596B.6030703@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Sasha Levin <levinsasha928@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hello Paolo,

On Mon, Jan 30, 2012 at 10:48 AM, Paolo Bonzini <pbonzini@redhat.com> w=
rote:
> On 01/20/2012 05:45 PM, Paolo Bonzini wrote:
>>
>> This is the first implementation of the virtio-scsi driver, a virtua=
l
>> HBA that will be supported by KVM. =A0It implements a subset of the =
spec,
>> in particular it does not implement asynchronous notifications for e=
ither
>> LUN reset/removal/addition or CD-ROM media events, but it is already
>> functional and usable.
>>
>> Other matching bits:
>>
>> - spec at http://people.redhat.com/pbonzini/virtio-spec.pdf
>>
>> - QEMU implementation at git://github.com/bonzini/qemu.git,
>> =A0 branch virtio-scsi
>>
>> Please review. =A0I would like this to be included in 3.3, since the
>> possibility of regressions is obviously zero.
>>
>> Paolo Bonzini (3):
>> =A0 virtio-scsi: first version
>> =A0 virtio-scsi: add error handling
>> =A0 virtio-scsi: add power management support
>>
>> v3->v4: renamed VIRTIO_SCSI_S_UNDERRUN to VIRTIO_SCSI_S_OVERRUN;
>> =A0 =A0 fixed 32-bit compilation; added power management support;
>> =A0 =A0 adjusted calls to virtqueue_add_buf
>>
>> =A0drivers/scsi/Kconfig =A0 =A0 =A0 =A0| =A0 =A08 +
>> =A0drivers/scsi/Makefile =A0 =A0 =A0 | =A0 =A01 +
>> =A0drivers/scsi/virtio_scsi.c =A0| =A0594
>> +++++++++++++++++++++++++++++++++++++++++++
>> =A0include/linux/virtio_ids.h =A0| =A0 =A01 +
>> =A0include/linux/virtio_scsi.h | =A0114 +++++++++
>> =A05 files changed, 718 insertions(+), 0 deletions(-)
>> =A0create mode 100644 drivers/scsi/virtio_scsi.c
>> =A0create mode 100644 include/linux/virtio_scsi.h
>
> Ping?

What's the benefit of virtio-scsi over virtio-blk? Are we going to
support both or eventually phase out virtio-blk?

Have the virtio specification changes been reviewed? Can we guarantee
stable ABI for the virtio-scsi driver?

                        Pekka
