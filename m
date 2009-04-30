From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
Date: Thu, 30 Apr 2009 10:13:23 +0900
Message-ID: <49F8FB33.8020803@kernel.org>
References: <1233456951-992-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1233456951-992-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, Mauelshagen@RedHat.c
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> This patchset implements alt_size, which is a size hint to the users
> of a block device.  It's primarily to communicate the BIOS (HPA) size
> on ATA devices to userland, so that dmraid can consider it when trying
> to figure out BIOS raid layout.  This is critical as dmraid can be
> tricked into assemblying the wrong raid when fed with the unlocked
> size and if the disk content is right (or, rather, wrong) and good
> number of distros are shipping with ignore_hpa=1 as default.

PING.

-- 
tejun
