From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 0/3] SG_IO command filtering via sysfs
Date: Fri, 16 Nov 2018 12:35:51 -0500
Message-ID: <20181116173551.GG20617@thunk.org>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
 <20181110190521.GA2627@thunk.org>
 <566bc821-f12a-f7c1-e7c7-99092807ee27@redhat.com>
 <20181111141426.GA7377@thunk.org>
 <98fe5cf7-722a-37d6-156d-842e8812e430@redhat.com>
 <1542328654.100259.18.camel@acm.org>
 <c819493c-2a45-4911-8879-310c910ee42a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c819493c-2a45-4911-8879-310c910ee42a@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 16, 2018 at 08:01:29AM +0100, Paolo Bonzini wrote:
> On 16/11/18 01:37, Bart Van Assche wrote:
> > All user space interfaces in the Linux kernel for storage that I'm familiar
> > with not only allow configuration of parameters but also make it easy to
> > query which parameters have been configured. The existing sysfs and configfs
> > interfaces demonstrate this. Using BPF to configure SG/IO access has a
> > significant disadvantage, namely that it is very hard to figure out what has
> > been configured. Figuring out what has been configured namely requires
> > disassembling BPF. I'm not sure anyone will be enthusiast about this.
> 
> Well, that's a problem with BPF in general.  With great power comes
> great obscurability.

You can also make the same complaint about kernel modules; that it's
impossible to figure exactly what a kernel modules does without
disassembling them.  However, you can a one-line description of what
it does using modinfo:

% modinfo async_pq
filename:       /lib/modules/4.19.0-00022-g831156939ae8/kernel/crypto/async_tx/async_pq.ko
license:        GPL
description:    asynchronous raid6 syndrome generation/validation
srcversion:     529102C736C4FED181C15A8
depends:        raid6_pq,async_tx,async_xor
retpoline:      Y
intree:         Y
name:           async_pq
vermagic:       4.19.0-00022-g831156939ae8 SMP mod_unload modversions 

					       - Ted
