From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Status update for tcm_vhost driver merge
Date: Fri, 27 Jul 2012 13:33:22 -0700
Message-ID: <1343421202.22538.76.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>, hare@suse.de, Christoph Hellwig <hch@lst.de>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Andy Grover <agrover@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <gregkh@linuxfoundation.org>, Avi Kivity <avi@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

Hello folks,

The RFC-v5 patch for tcm_vhost kernel code was sent out for review a bit
less than 24 hours ago, and thus far there has not been any additional
comments..  Thanks to everyone who has been participating in the various
threads over the past week and giving their feedback!

Also, just a heads up that I've added a target-pending/for-linus branch
containing the same RFC-v5 code cut against recent commit bdc0077af574 @
-rc0 code has been added to include the net-next + scsi-misc bits now
merged into mainline.

This afternoon running tcm_vhost on -rc0 code the virtio-scsi client
(running 3.5-rc2 + scsi-misc bugfix now in mainline) is able to connect
+ perform target vhost LUN SCAN as expected.  The same heavy small block
mixed random I/O workloads are running with IBLOCK via raw flash
backends, and I'll be running more tests on -rc0 code over the next
days.

So this merge commit will likely be updated once more as MST returns
from a week of full of restful thoughts, but at this point his last
minor off-list comments have been addressed in RFC-v5 code.

Also, I'm not sure for an initial merge if upstream would prefer to just
pull with the necessary ACK from MST via for-next-merge here (and sort
out the vhost duplicates himself), or take a for-linus branch that's cut
on top of -rc0 with the necessary mainline deps..?

Linus (CC'ed), what would you prefer in this type of case..?

Thank you,

--nab



 
