From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 1/1] megaraid_{mm,mbox}: fix a bug in reset handler
Date: Tue, 18 Apr 2006 13:37:22 -0700
Message-ID: <20060418133722.7af041e3.akpm@osdl.org>
References: <890BF3111FB9484E9526987D912B261901BCDA@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:4308 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932328AbWDRUiQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Apr 2006 16:38:16 -0400
In-Reply-To: <890BF3111FB9484E9526987D912B261901BCDA@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: Seokmann.Ju@engenio.com, andre@linux-ide.org, James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

"Ju, Seokmann" <Seokmann.Ju@lsil.com> wrote:
>
> I've seen the patch (megaraid_mmmbox_fix_a_bug_in_reset_handler.patch) available on 2.6.17-rc1-mm3 under "SCSI warning fix" section.
>  What should I do to remove "warning" tag on the patch.
>  I've attached another patch in previous email that has 'udelay()' in the loop to remove NMI concern, and waiting for confirmation on it. Will this change remove the "warning"?
> 
>  I'll submit the patch officially by end of today.

There are four megaraid-specific patches in -mm:

megaraid-unused-variable.patch
drivers-scsi-megaraidc-add-a-dummy-mega_create_proc_entry-for-proc_fs=y.patch
scsi-megaraid-megaraid_mmc-fix-a-null-pointer-dereference.patch
megaraid_mmmbox-fix-a-bug-in-reset-handler.patch

The final one is your latest patch.

I'll periodically send such patches to the subsystem maintainer until
something happens.  
