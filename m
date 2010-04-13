From: Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH 1/2] RFC: iscsi ibft: separate ibft parsing from sysfs interface
Date: Mon, 12 Apr 2010 22:20:29 -0400
Message-ID: <201004122220.30193.konrad@darnok.org>
References: <1271095578-4212-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1271095578-4212-1-git-send-email-michaelc@cs.wisc.edu>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, pjones@redhat.com, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Monday 12 April 2010 14:06:17 michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
>
> Not all iscsi drivers support ibft. For drivers like be2iscsi
> that do not but are bootable through a vendor firmware specific
> format/process this patch moves the sysfs interface from the ibft code
> to a lib module. This then allows userspace tools to search for iscsi boot
> info in a common place and in a common format.
>
> ibft iscsi boot info is exported in the same place as it was
> before: /sys/firmware/ibft.
>
> vendor/fw boot info gets export in /sys/firmware/iscsi_bootX, where X is
> the scsi host number of the HBA. Underneath these parent dirs, the
> target, ethernet, and initiator dirs are the same as they were before.
>
> This patch was made over the ibft-2.6 tree's ibft-1.03 branch:
> http://git.kernel.org/?p=linux/kernel/git/konrad/ibft-2.6.git;a=shortlog;h=
>refs/heads/ibft-1.03
>
>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
Looks good to my eyes.

Let me run it tomorrow through my regression bucket before I stick on the git 
tree.
