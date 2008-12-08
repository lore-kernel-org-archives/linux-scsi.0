From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2/2] mpt fusion: port "4.00.43.00" to mainstream git
	kernel
Date: Sun, 7 Dec 2008 20:59:15 -0800
Message-ID: <20081208045915.GA14968@kroah.com>
References: <1228483610-18502-1-git-send-email-crquan@gmail.com> <1228483610-18502-2-git-send-email-crquan@gmail.com> <91b13c310812071851s5a82d52em63f86f1d3aa42ee9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:37448 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750738AbYLHFDN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Dec 2008 00:03:13 -0500
Content-Disposition: inline
In-Reply-To: <91b13c310812071851s5a82d52em63f86f1d3aa42ee9@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Cheng Renquan <crquan@gmail.com>
Cc: Eric Moore <Eric.Moore@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chengrq@uit.com.cn

On Mon, Dec 08, 2008 at 10:51:48AM +0800, Cheng Renquan wrote:
> Hi, all,
> 
> I have tested and verified that these two patches can let my LSI-SAS-1068E
> controllers work well with 2.6.26.2 kernels, perfect,
> 
> Tested-by: Cheng Renquan <crquan@gmail.com>
> 
> but the latest git kernel has not yet been tested. just buildable. I
> personally suggest these patches integrated into Greg KH's staging
> tree. It seems meet staging's purpose well?

The staging tree is for new drivers that are not already included in the
kernel tree.  Not for patches to existing drivers, that wouldn't really
work out.

thanks,

greg k-h
