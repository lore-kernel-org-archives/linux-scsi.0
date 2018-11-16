From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/3] SG_IO command filtering via sysfs
Date: Fri, 16 Nov 2018 08:01:29 +0100
Message-ID: <c819493c-2a45-4911-8879-310c910ee42a@redhat.com>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
 <20181110190521.GA2627@thunk.org>
 <566bc821-f12a-f7c1-e7c7-99092807ee27@redhat.com>
 <20181111141426.GA7377@thunk.org>
 <98fe5cf7-722a-37d6-156d-842e8812e430@redhat.com>
 <1542328654.100259.18.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542328654.100259.18.camel@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 16/11/18 01:37, Bart Van Assche wrote:
> All user space interfaces in the Linux kernel for storage that I'm familiar
> with not only allow configuration of parameters but also make it easy to
> query which parameters have been configured. The existing sysfs and configfs
> interfaces demonstrate this. Using BPF to configure SG/IO access has a
> significant disadvantage, namely that it is very hard to figure out what has
> been configured. Figuring out what has been configured namely requires
> disassembling BPF. I'm not sure anyone will be enthusiast about this.

Well, that's a problem with BPF in general.  With great power comes
great obscurability.

Paolo
