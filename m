From: Andrew Morton <akpm@osdl.org>
Subject: Re: [RFC] [PATCH 1/2] introduce crashboot kernel command line
 parameter
Date: Fri, 23 Jun 2006 23:55:14 -0700
Message-ID: <20060623235514.48ea9578.akpm@osdl.org>
References: <20060623210121.GA18384@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:62436 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750879AbWFXGzV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Jun 2006 02:55:21 -0400
In-Reply-To: <20060623210121.GA18384@in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vgoyal@in.ibm.com
Cc: linux-kernel@vger.kernel.org, fastboot@lists.osdl.org, linux-scsi@vger.kernel.org, ebiederm@xmission.com, mike.miller@hp.com

On Fri, 23 Jun 2006 17:01:21 -0400
Vivek Goyal <vgoyal@in.ibm.com> wrote:

> o Add kernel command line option "crashboot"
> 
> o This option is an indication to the kernel that kernel is booting in an
>   unreliable environment where possibly BIOS execution has been skipped
>   and devices are left operational or in unknown state.
> 
> o Kernel, especially device drivers can use this option to take special
>   actions like soft-resetting the device, relaxing some of the rules
>   to make sure kernel can boot/device driver can initiliaze in this
>   environment.
> 
> o As of today this option is useful to Kdump. Kdump will pass this option
>   to second kernel to improve the reliability of successful kenrel boot/
>   device driver initializatoin. 

It worries me that this will be used to work around driver problems rather
than fixing them properly.

