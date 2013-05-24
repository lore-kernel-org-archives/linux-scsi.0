From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3 part1 1/4] sg_io: pass request_queue to
 blk_verify_command
Date: Fri, 24 May 2013 11:36:05 +0400
Message-ID: <1369380965.1945.10.camel@dabdike>
References: <1369317503-4095-1-git-send-email-pbonzini@redhat.com>
	 <1369317503-4095-2-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369317503-4095-2-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, stable@gnu.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-05-23 at 15:58 +0200, Paolo Bonzini wrote:
> Adjust the blk_verify_command function to let it look at per-queue
> data.  This will be done in the next patch.

This is not a bug fix.  This is an enabler for your complex and to my
mind dubious rework of the SG_IO command filter.  I'm running out of
ways to say please don't mix bug fixes with features, because this
redesignating of the original patch set as part 1 and parts 2,3 doesn't
satisfy the requirement.

Does anyone in the real world actually care about this bug?  because if
not perhaps we can just remove the confusion and consider this as a
feature set.  If there's someone who actually cares, please lets just do
the bug fix first and argue about the feature later.

James
