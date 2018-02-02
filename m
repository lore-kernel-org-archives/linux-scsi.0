From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 02/10] ufs: sysfs: device descriptor
Date: Fri, 2 Feb 2018 08:17:35 +0100
Message-ID: <20180202071735.GC9314@kroah.com>
References: <1517501746-19075-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1517501746-19075-3-git-send-email-stanislav.nijnikov@wdc.com>
 <1517531145.2746.26.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38536 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbeBBHRi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2018 02:17:38 -0500
Content-Disposition: inline
In-Reply-To: <1517531145.2746.26.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jaegeuk@kernel.org" <jaegeuk@kernel.org>, Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>, Alex Lemberg <Alex.Lemberg@wdc.com>

On Fri, Feb 02, 2018 at 12:25:46AM +0000, Bart Van Assche wrote:
> On Thu, 2018-02-01 at 18:15 +0200, Stanislav Nijnikov wrote:
> > +enum ufs_desc_param_size {
> > +	UFS_PARAM_BYTE_SIZE	= 1,
> > +	UFS_PARAM_WORD_SIZE	= 2,
> > +	UFS_PARAM_DWORD_SIZE	= 4,
> > +	UFS_PARAM_QWORD_SIZE	= 8,
> > +};
> 
> Please do not copy bad naming choices from the Windows kernel into the Linux
> kernel. Using names like WORD / DWORD / QWORD is much less readable than using
> the numeric constants 2, 4, 8. Hence my proposal to leave out the above enum
> completely.

Are you sure those do not come from the spec itself?  It's been a while
since I last read it, but for some reason I remember those types of
names being in there.  But I might be confusing specs here.

thanks,

greg k-h
