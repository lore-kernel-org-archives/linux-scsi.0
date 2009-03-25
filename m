From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 06/13] [scsi] changed ioctls to unlocked
Date: Tue, 24 Mar 2009 22:21:09 -0600
Message-ID: <20090325042109.GP14127@parisc-linux.org>
References: <1237929168-15341-7-git-send-email-stoyboyker@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35372 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbZCYEV1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Mar 2009 00:21:27 -0400
Content-Disposition: inline
In-Reply-To: <1237929168-15341-7-git-send-email-stoyboyker@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stoyboyker@gmail.com
Cc: linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Tue, Mar 24, 2009 at 04:12:41PM -0500, stoyboyker@gmail.com wrote:
> +static long osst_ioctl(struct file * file, unsigned int cmd_in,
> +	unsigned long arg)
>  {
> +	lock_kernel();
>  	int		      i, cmd_nr, cmd_type, blk, retval = 0;

Did you try compiling this?  If so, what compiler did you use?  You
*should* have got an error about mixing code and declarations.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
