From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 07/12] qla2xxx: Convert to host_lock less w/ interrupts
 disabled externally
Date: Sun, 19 Dec 2010 19:19:10 -0500
Message-ID: <4D0EA0FE.4090104@garzik.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org> <1292793727-31957-8-git-send-email-nab@linux-iscsi.org> <20101219231114.GI1263@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101219231114.GI1263@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Douglas Gilbert <dgilbert@interlog.com>, adam radford <aradford@gmail.com>, Kashyap Desai <Kashyap.Desai@lsi.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>
List-Id: linux-scsi@vger.kernel.org

On 12/19/2010 06:11 PM, Matthew Wilcox wrote:
> I'm not sure this is the right direction to go.  Now that Jeff's done
> the pushdown and put in the compatibility macros, I don't think it makes
> sense to do another partial transition on each driver.  Much better to
> take our time, analyse each driver thoroughly, and kill the DEF_SCSI_QCMD
> in each driver without introducing IRQ_DISABLE_SCSI_QCMD.


Agreed...   DEF_SCSI_QCMD was intended, as you note, to encourage a 
piecemeal, in-depth approach to cleaning up the rest of the drivers. 
Hopefully DEF_SCSI_QCMD removal means someone actually figured out [or 
already knew] the locking for a driver, and created the most appropriate 
patch, rather than another half-step.

	Jeff
