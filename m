From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] st: fix race in st_scsi_execute_end
Date: Wed, 21 Mar 2012 10:09:41 +0000
Message-ID: <1332324581.2909.38.camel@dabdike.int.hansenpartnership.com>
References: <20111021113108.GA26181@foxbat.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111021113108.GA26181@foxbat.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Petr Uzel <petr.uzel@suse.cz>
Cc: linux-kernel@vger.kernel.org, Willem Riede <osst@riede.org>, jack@suse.cz, linux-scsi@vger.kernel.org, juergen.gross@ts.fujitsu.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 2011-10-21 at 13:31 +0200, Petr Uzel wrote:
> The call to complete() in st_scsi_execute_end() wakes up sleeping thread
> in write_behind_check(), which frees the st_request, thus invalidating
> the pointer to the associated bio structure, which is then passed to the
> blk_rq_unmap_user(). Fix by storing pointer to bio structure into
> temporary local variable.
> 
> This bug is present since at least linux-2.6.32.

This patch isn't applyable.  That's because gpg has mangled it.  You
either need to turn it off or do detached signatures.

Thanks,

James
