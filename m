From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] scsi: virtio-scsi: Fix address translation failure
 of HighMem pages used by sg list
Date: Wed, 25 Jul 2012 14:50:09 +0200
Message-ID: <500FEB81.4020008@redhat.com>
References: <1343218390-24310-1-git-send-email-senwang@linux.vnet.ibm.com> <500FE7C9.3000703@redhat.com> <500FEAC7.2050803@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <500FEAC7.2050803@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 25/07/2012 14:47, Boaz Harrosh ha scritto:
> 
> NACK-by: Boaz Harrosh
> 
> 
> Apart from the HighMem pages problem, where in previous sg_set_buf()
> code was the marker copied? It was not because it is not needed because
> the allocation of sg took care of that. For example in 64bit the is no
> bugs, right?
> 
> If there was a destination sg_list termination bug, it should be fixed
> as a separate patch from this "HighMem pages problem". But I bet if
> you inspect the code carefully there isn't such a bug.

Hmm, we're talking past each other.  Let's sort it out in the v1 thread.
 Sen, please hold up the patch for a moment.

Paolo
