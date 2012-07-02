From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: Add SG_GET_SG_MAX_SEGMENT_SIZE ioctl to sg device
Date: Mon, 02 Jul 2012 12:18:17 +0100
Message-ID: <1341227897.2987.15.camel@dabdike.int.hansenpartnership.com>
References: <1341220857-1205-1-git-send-email-mc@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341220857-1205-1-git-send-email-mc@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Cong Meng <mc@linux.vnet.ibm.com>
Cc: stefanha@linux.vnet.ibm.com, linuxram@us.ibm.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, senwang@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-07-02 at 17:20 +0800, Cong Meng wrote:
> Add a new ioctl cmd to get the max segment size. It's useful in
> virtualization environment for guest to know the queue limits, so
> that the guest kicks off legal scsi command to a sg device.

What's wrong with simply looking in the /sys for this? Plus, if you can
come up with a justifiable reason, this needs to be in block as well so
we can send it to all SCSI devices regardless of what ULD people use.

James
