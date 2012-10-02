From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/2] virtio-scsi fixes for 3.6
Date: Tue, 02 Oct 2012 11:12:13 +0200
Message-ID: <506AAFED.2050600@redhat.com>
References: <1343309288-32615-1-git-send-email-pbonzini@redhat.com>  <50699682.9020804@redhat.com> <1349165906.2406.13.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1349165906.2406.13.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Il 02/10/2012 10:18, James Bottomley ha scritto:
> On Mon, 2012-10-01 at 15:11 +0200, Paolo Bonzini wrote:
>> Il 26/07/2012 15:28, Paolo Bonzini ha scritto:
>>> James,
>>>
>>> patch 1 fixes scanning of LUNs whose number is greater than 255.  QEMU
>>> passes a max_lun of 16383 (because it uses SAM numbering) but in Linux
>>> it must become 32768 (because LUNs above 255 are "relocated" to 16640).
>>> Patch 2 is a resubmission of the patch for online resizing of virtio-scsi
>>> LUNs, which needs to be rebased.
>>>
>>> LUNs above 255 now work for all of scanning, hotplug, hotunplug and
>>> resize.
>>>
>>> Thanks,
>>>
>>> Paolo
>>>
>>> Paolo Bonzini (2):
>>>   virtio-scsi: fix LUNs greater than 255
>>>   virtio-scsi: support online resizing of disks
>>>
>>>  drivers/scsi/virtio_scsi.c  |   37 +++++++++++++++++++++++++++++++++++--
>>>  include/linux/virtio_scsi.h |    2 ++
>>>  2 files changed, 37 insertions(+), 2 deletions(-)
>>>
>>
>> Ping, are these patches going into 3.7?
> 
> They're 3.7 candidates yes (enhancements certainly aren't 3.6).
> I seem to have become lost with the virtio-scsi updates since what I have
> marked for inclusion is a patch series that's a partial intersection
> with this.  I'll flush my queue for virto-scsi, please resend all the
> missing patches you want in 3.7.

Ok, will do so soon and tag the appropriate ones for stable.

Paolo
