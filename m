From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [ANNOUNCE] lio-utils.git v3.0 configfs HOWTO for v2.6.30 released
Date: Tue, 16 Jun 2009 13:57:17 -0700
Message-ID: <1245185837.4232.179.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:31158 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762509AbZFPVD4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jun 2009 17:03:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>
Cc: Joel Becker <joel.becker@oracle.com>, Leonid Grossman <leonid.grossman@neterion.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Philipp Reisner <philipp.reisner@linbit.com>, Florian Haas <florian.haas@linbit.com>, Avi Kivity <avi@redhat.com>, "J.H." <warthog9@kernel.org>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>

Grettings all,

The Linux-iSCSI.org Target v3.0 HOWTO using the new configfs enabled
generic target subsystem python CLI has been released and is up and
running on v2.6.30 of the Linux Kernel in x86_64 KVM (Debian), x86_64
bare-metal (SLES) and PPC64 (Fedora PS3) hosts!  The HOWTO entry can be
found at:

http://linux-iscsi.org/index.php/Howto

The v3.0 howto is a WIP and currently expects that the reader is fimilar
with building and installing their own LIO target modules within a linux
kernel source.  There is currently work being done to integrate this
into virtual machines imagines ot make the v3.0 LIO CLI more accessable
for end users.  We are expecting the v3.0 work to be available in a
couple of different forms soon.  Until then, interested folks should
have a look at the v3.0 howto and the lio-utils.git source tree for
usage information and towards build their own copy from source.

So far using the lio-utils.git tools for the Generic Target Core v3.0
with LIO-Target configfs enabled symlinks, the code has been able to
scale to 10000 unique Virtual HBA+FILEIO LUNs with SCSI 3 emulation <->
10000 unique LIO-Target v3.0 Endpoints inside of a 4GB memory x86_64 KVM
guest on recent x86_64 hardware.  Each of these HBA+LUNs and iSCSI
Target Endpoints are designed (using the TCM+LIO configfs kernel
infrastructure) to be configured completely independent of one another,
so that creating/changing one does not effect the real-time configfs ops
of another.

The configs CLI commands to reproduce the running setup can be dumped at
any time for the entire running setup using tcm_dump.py and lio_dump.py.
The lio-utils.git source repository is for v3.0 target_core_mod
+iscsi_target_mod configfs enabled code in lio-core-2.6.git:

http://git.kernel.org/?p=linux/storage/lio/lio-utils.git;a=summary

Additional information can be found here:

http://linux-iscsi.org/index.php/Lio-utils

Questions can be asked via the LIO-Devel or LIO-Users:

http://groups.google.com/group/linux-iscsi-target-dev
http://groups.google.com/group/linux-iscsi-target-users

The former is where most folks today (devels+users) are doing most of
their work, and thanks to the many people has been helping improve the
code!  I would like to encourage new end users to start posting in
linux-iscsi-targets-users as they get their v3.0 LIO-Target with
tcm_node.py + lio_node.py setups up and running with general questions
and comments.  

Also a special thanks to the kernel.org folks (warthog9 and hpa)
assitance with getting the lio-utils.git source repository up and
running, it would not be possible without their help.  Thank you!

--nab











