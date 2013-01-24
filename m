From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 06/13] sg_io: whitelist a few more commands for
 multimedia devices
Date: Thu, 24 Jan 2013 14:55:55 -0800
Message-ID: <20130124225555.GC2373@mtj.dyndns.org>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
 <1359039649-17734-7-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1359039649-17734-7-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 24, 2013 at 04:00:42PM +0100, Paolo Bonzini wrote:
> Strangely, a couple of MMC commands were never included.  Add them too.

What are the justifications for adding these commands to the filter?
Are there users requesting these?

Thanks.

-- 
tejun
