From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [target:for-next 20/20] drivers/scsi/virtio_scsi.c:531:48:
 error: dereferencing pointer to incomplete type
Date: Tue, 27 May 2014 15:21:44 -0700
Message-ID: <1401229304.12413.24.camel@haakon3.risingtidesystems.com>
References: <537d6b74.lQGMmmapPq/MP5Nx%fengguang.wu@intel.com>
	 <1400791590.26558.6.camel@haakon3.risingtidesystems.com>
	 <537F12C1.4080407@redhat.com>
	 <1400867110.30565.6.camel@haakon3.risingtidesystems.com>
	 <yq1d2f0ih1i.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:57613 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbaE0WVq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2014 18:21:46 -0400
In-Reply-To: <yq1d2f0ih1i.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2014-05-26 at 13:30 -0400, Martin K. Petersen wrote:
> >>>>> "Nic" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:
> 
> >> What about #ifdef'ing VIRTIO_SCSI_F_T10_PI support out if
> >> !CONFIG_BLK_DEV_INTEGRITY?
> 
> Nic> I figured it was slightly cleaner to enable BLK_DEV_INTEGRITY by
> Nic> default when referencing struct blk_integrity (following what
> Nic> IBLOCK does), than adding the equivalent #ifdef's..
> 
> Nic> MKP, do you have a preference on this..?
> 
> Well, I guess how important the virtio stuff is in the embedded space?
> 
> In the block layer we have all these wrappers that allow things to Do
> The Right Thing when the BLK_DEV_INTEGRITY is disabled. I'm not entirely
> sure it worth the hassle to do the same for target and virtio. The
> memory savings aren't that big to begin with.
> 
> And besides, the bip pointer field in struct bio is about to become
> generic with my impending copy offload patches anyway,
> 

In that case, I'll leave as is unless Paolo has an objection.

--nab

