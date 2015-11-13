From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [GIT PULL] target updates for v4.4-rc1
Date: Fri, 13 Nov 2015 09:24:46 -0800
Message-ID: <56461CDE.308@sandisk.com>
References: <1447408811.23126.110.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447408811.23126.110.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Felipe Balbi <balbi@ti.com>, James Bottomley <james.bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On 11/13/2015 02:00 AM, Nicholas A. Bellinger wrote:
> Hello Linus,
>
> Apologies for the late PULL request.
>
> Please pull from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next
>
> This series contains HCH's changes to absorb configfs attribute ->show()
> + ->store() function pointer usage from it's original tree-wide
> consumers, into common configfs code.
>
> It includes usb-gadget, target w/ drivers, netconsole and ocfs2 changes
> to realize the improved simplicity, that now renders the original
> include/target/configfs_macros.h CPP magic for fabric drivers and
> others, unnecessary and obsolete.
>
> And with common code in place, new configfs attributes can be added
> easier than ever before.
>
> Note, there are further improvements in-flight from other folks for v4.5
> code in configfs land, plus number of target fixes for post -rc1 code.

Hello Nic,

Although the first version of my patch series that makes ABORT and LUN 
RESET handling synchronous was posted six months ago, although this 
patch series significantly improves reliability of the target core and 
also improves source code readability and although the entire patch 
series has received positive reviews from three experienced kernel 
developers I am still waiting for feedback from you about the technical 
aspects of these patches. You are the maintainer of the in-tree SCSI 
target subsystem so it is your role to provide feedback on patches for 
this subsystem.

The patch series I am referring to is "SCSI target patches for kernel 
v4.4" (http://thread.gmane.org/gmane.linux.scsi.target.devel/10365).

Bart.
