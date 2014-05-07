From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 2/2] virtio_scsi: remove smp_read_barrier_depends
Date: Wed, 7 May 2014 22:36:27 +0800
Message-ID: <CACVXFVMx-P4uvyDy4UnxByA-ZHopoOCHC5Fh33P+AQk2VDSoBA@mail.gmail.com>
References: <1399471989-17890-1-git-send-email-tom.leiming@gmail.com>
	<536A40A1.6000805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:60545 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbaEGOg2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2014 10:36:28 -0400
Received: by mail-vc0-f180.google.com with SMTP id hy4so577804vcb.11
        for <linux-scsi@vger.kernel.org>; Wed, 07 May 2014 07:36:27 -0700 (PDT)
In-Reply-To: <536A40A1.6000805@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Wanlong Gao <gaowanlong@cn.fujitsu.com>, Rusty Russell <rusty@rustcorp.com.au>

On Wed, May 7, 2014 at 10:18 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>
> tgt_lock is held to serialize reading and writing req_vq.  Reading req_vq
> could be done locklessly, but we do not do it yet.
>
> You can also merge the two patches together.

OK, please ignore these two patches, and I have sent out
the merged one.


Thanks,
-- 
Ming Lei
