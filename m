From: Venkatesh Srinivas <venkateshs@google.com>
Subject: Re: [PATCH v2 2/6] virtio-scsi: replace target spinlock with seqcount
Date: Wed, 4 Jun 2014 10:24:07 -0700
Message-ID: <CAHdzE-9vDGyHg1bvnUUUwUyRDQAJC_8Mb+ghYVgHMY8Rs1j3Kw@mail.gmail.com>
References: <1401876703-10236-1-git-send-email-pbonzini@redhat.com>
	<1401876703-10236-3-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:50158 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbaFDRYI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2014 13:24:08 -0400
Received: by mail-ig0-f180.google.com with SMTP id c1so1314851igq.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Jun 2014 10:24:07 -0700 (PDT)
In-Reply-To: <1401876703-10236-3-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, JBottomley@parallels.com, Ming Lei <ming.lei@canonical.com>, Venkatesh Srinivas <vsrinivas@ops101.org>

On 6/4/14, Paolo Bonzini <pbonzini@redhat.com> wrote:
> From: Ming Lei <ming.lei@canonical.com>
>
> The spinlock of tgt_lock is only for serializing read and write
> req_vq, one lockless seqcount is enough for the purpose.
>
> On one 16core VM with vhost-scsi backend, the patch can improve
> IOPS with 3% on random read test.
>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> [Add initialization in virtscsi_target_alloc. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Venkatesh Srinivas <venkateshs@google.com>

-- vs;
