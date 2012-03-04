From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command
 to the host
Date: Sun, 04 Mar 2012 08:19:30 -0600
Message-ID: <1330870770.2858.4.camel@dabdike.int.hansenpartnership.com>
References: <1330721347-26781-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1330721347-26781-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, hch@infradead.org, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-03-02 at 12:49 -0800, K. Y. Srinivasan wrote:
> Windows hosts don't handle the ATA_16 command; don't pass it to the host.

What do you mean by this?  Most SCSI devices don't handle ATA_16 because
it's only useful if the device is actually an ATA device behind a
bridge.

As a general rule, you shouldn't filter in the driver commands you think
the host won't want to see, you should let the host reply with an error
code.  You should *only* filter commands that cause an actual bug in the
host.  Is the latter the case for this command (if so that needs to be
explained)?

> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

This signoff chain doesn't make sense, since you're sending me the patch
and apparently you authored it.

James
