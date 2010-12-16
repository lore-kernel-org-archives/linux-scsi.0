From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] block/SCSI: implement in-kernel disk event handling,
 take#2
Date: Thu, 16 Dec 2010 17:31:29 +0100
Message-ID: <4D0A3EE1.4050404@kernel.org>
References: <1291838262-21274-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1291838262-21274-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, jack@suse.cz, James.Bottomley@HansenPartnership.com
List-Id: linux-scsi@vger.kernel.org

On 12/08/2010 08:57 PM, Tejun Heo wrote:
> This is the second take of in-kernel-disk-event patchset which
> implements in-kernel disk event handling framework and adds support
> for it to sr and sd.  This is largely to move media presence polling
> into kernel as userspace implementation turned out to be quite
> problematic over the years.

Kay, Jens, James, how does this look to you guys?

Thanks.

-- 
tejun
