From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [ANNOUNCE] target-pending tree updated to v3.6-rc2
Date: Thu, 16 Aug 2012 19:43:32 -0700
Message-ID: <1345171412.25161.134.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Andy Grover <agrover@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi all,

With the release of v3.6-rc2 this afternoon, the target-pending.git tree
now has been updated using the freshly cut -rc2 as it's new HEAD.
Patches destined into for-3.7 code are now being added into for-next for
linux-next build testing.

Also, thanks go out to MST, Stefan, and Paolo who managed to get
tcm_vhost fabric code merged in mainline for -rc2  under the special
post merge window exception rule for new kernel code, which in my
experience tends to happens about as often as Haley's comet comes
around..

Here is the current breakdown of pending patches by branch:

master: (patches headed for 3.6-rc-fixes)

5b7517f8 tcm_vhost: Change vhost_scsi_target->vhost_wwpn to char *
d0e27c88 target: fix NULL pointer dereference bug alloc_page() fails to get memory
1fa8f450 tcm_fc: Avoid debug overhead when not debugging
101998f6 tcm_vhost: Post-merge review changes requested by MST
f0e0e9bb tcm_vhost: Fix incorrect IS_ERR() usage in vhost_scsi_map_iov_to_sgl

for-next: (patches headed for-3.7 merge window)

6a922a33 target: Fix minor spelling typos in drivers/target
867c8e7d target: Simplify fabric sense data length handling
3ab2a995 target: Remove unused target_core_fabric_ops.get_fabric_sense_len method
7b43c0e6 target/sbp: Remove strict param from sbp_parse_wwn
0fa5702d target: Cleanup transport_subsystem_check_init
6fc3933f target: Remove request_module for target_core_stgt

for-next-merge: (new fabric drivers headed for 3.7 merge window)

None

queue: (recent patches needing more review/testing before committing)

9b840e4c target: Fix regression bug with handling of zero-length data CDBs
e093f8a5 target: Fix ->data_length re-assignment bug with SCSI overflow
0aa8cc14 target: Remove unused se_cmd.cmd_spdtl

--

Please let me know if anything is missing from the list, and I'll plan
to send out a PULL request for outstanding master -> 3.6-rc-fixes
sometime next week.

Thanks!

--nab
