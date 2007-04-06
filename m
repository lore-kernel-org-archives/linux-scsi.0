From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: CONFIG_SCSI_WAIT_SCAN=m
Date: Fri, 06 Apr 2007 10:51:10 -0500
Message-ID: <1175874670.3677.14.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.64.0703271658380.26754@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1767796AbXDFPvh@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703271658380.26754@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

Sorry, was waiting for a reply on this one ... didn't realise it hadn't
cc'd linux-scsi ...

James

On Tue, 2007-03-27 at 17:25 +0100, Hugh Dickins wrote:
> I'm not using an initrd, most of my kernel is builtin,
> just a few modules for occasional filesystems.
> 
> CONFIG_MODULES=y
> CONFIG_SCSI=y
> CONFIG_SCSI_SCAN_ASYNC=y
> CONFIG_SCSI_WAIT_SCAN=m
> 
> 2.6.21-rc5-mm2 VFS panics unable to find my root on /dev/sda2,
> but boots okay if I change drivers/scsi/Kconfig to "default y"
> instead of "default m" for SCSI_WAIT_SCAN.
> 
> I'm sure that's not the right fix, but I don't know what is.
> 
> I've had no trouble with SCSI_SCAN_ASYNC=y until now: I could
> turn it off, but others may have trouble with the same regression.
> 
> Hugh
