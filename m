From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 00/12] LLD host_lock-less conversion status for .38
Date: Mon, 20 Dec 2010 11:33:40 -0800
Message-ID: <AANLkTi=+QhTdWFEtu9UD9AJC_N+UET8i+7F_qzOS5Znt@mail.gmail.com>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Douglas Gilbert <dgilbert@interlog.com>, Kashyap Desai <Kashyap.Desai@lsi.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Dec 19, 2010 at 1:21 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> *) megaraid_sas: Running in host_lock-less mode with MSI-X interrupts
>
> This has not been tested yet, but I would like to get some review from the LSI
> megaraid_sas folks now that their patches to enable MSI-X interrupts has been sent
> to linux-scsi.
>
> AdamR, any thoughts or comments to add here..?

Nick,

Your patch will not work with the new MegaRAID adapter support I have
sent in recently.  It requires the build IO path be synchronized with
map updates with the host_lock.

-Adam
