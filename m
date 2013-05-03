From: Or Gerlitz <or.gerlitz@gmail.com>
Subject: Re: initial LIO iSER performance numbers [was: GIT PULL] target
 updates for v3.10-rc1)
Date: Fri, 3 May 2013 09:57:20 +0300
Message-ID: <CAJZOPZ+9kwqDm5xvxZ8jLDSRnR_f7L7r7SfApNwU6fVN3o8C4g@mail.gmail.com>
References: <1367290766.16334.77.camel@haakon3.risingtidesystems.com>
	<51827114.9010907@mellanox.com>
	<1367523115.23900.118.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1367523115.23900.118.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Or Gerlitz <ogerlitz@mellanox.com>, "linux-rdma (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Asias He <asias@redhat.com>, Roland Dreier <roland@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, ewg@lists.openfabrics.org, Shlomi Sasson <shlomis@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 2, 2013 at 10:31 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:

>> We used RAMDISK_MCP backend which was patched to act as NULL device, so
>> we can test the raw iSER wire performance.

> Btw, I'll be including a similar patch to allow for RAMDISK_NULL to be
> configured as a NULL device mode.

yep, that would be very helpful, so people can do that sort of testing
without hacks...

Or.
