From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 0/4] SG_IO filtering via sysfs and minimal whitelist
Date: Tue, 25 Jun 2013 23:19:08 +0200
Message-ID: <51CA094C.1080400@redhat.com>
References: <1369662622-5959-1-git-send-email-pbonzini__802.478011655872$1369666532$gmane$org@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369662622-5959-1-git-send-email-pbonzini__802.478011655872$1369666532$gmane$org@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, msnitzer@redhat.com, ksievers@redhat.com, jbottomley@parallels.com, axboe@kernel.dk, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 27/05/2013 15:50, Paolo Bonzini ha scritto:
> 
> We've been running in circles for nine months now.  Let's restart from
> the maintainer's suggestion, which was probably dismissed too quickly.
> 
> This is still not a complete solution, because /dev/sgN does not have
> access to its queue object.  Still, it can be a base for discussion.
> 
> If accepted (in a complete form with access to the queue object for
> non-block devices), this series removes the need to fix the opcode
> conflicts as far as I'm concerned.  We could just consider that a
> feature of CONFIG_BLK_DEV_SG_FILTER_MMC.
> 
> Previously posted at https://lkml.org/lkml/2012/9/25/397 (short thread).
> Rebased just fine, this one is compile-tested only.
> 
> Paolo

RFC didn't get many Cs.

Paolo
