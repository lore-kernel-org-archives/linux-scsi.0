From: Halim Issa <yallaone@gmail.com>
Subject: Re: sd incorrectly reports write cache disabled on cache-capable drives/controllers
Date: Fri, 25 Jan 2008 22:28:22 +0100
Message-ID: <200801252228.22659.yallaone@gmail.com>
References: <200801252159.20858.yallaone@gmail.com> <1201295720.3119.51.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:57715 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575AbYAYV2a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jan 2008 16:28:30 -0500
Received: by fg-out-1718.google.com with SMTP id e21so780972fga.17
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jan 2008 13:28:29 -0800 (PST)
In-Reply-To: <1201295720.3119.51.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

Thank you so much for the quick reply - I risk asking one follow-up question.

On Friday 25 January 2008 22:15:20 James Bottomley wrote:
> The "cache" hear would be referring to the RAID controller cache, not
> the disk cache.  Likewise DPO and FUA refer to what the RAID controller
> can support, not the disk.

Would it be safe to assume that the problem thus lies within the mptfusion 
driver, since a) the LSI Logic controller in question does indeed have 
hardware cache capabilities; and b) an older kernel version as well as 
Windows Server, correctly loads with the correct cache parameters at boot?

What would be the correct path forward to trouble-shoot this further in order 
to get the driver to utilize the maximum hardware capabilities in the generic 
kernel.org kernels?

Thanks again, and I apologize in advance if my questions are too basic for 
this list. 

