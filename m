From: Christoph Hellwig <hch@infradead.org>
Subject: Re: How to add/drop SCSI drives from within the driver?
Date: Fri, 3 Dec 2004 16:22:03 +0000
Message-ID: <20041203162203.GA14438@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E570230CA70@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:23214 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262312AbULCQWN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Dec 2004 11:22:13 -0500
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570230CA70@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: "'brking@us.ibm.com'" <brking@us.ibm.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, 'Andrew Morton' <akpm@osdl.org>, "'Matt_Domsch@dell.com'" <Matt_Domsch@dell.com>, "Ju, Seokmann" <sju@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>

On Fri, Dec 03, 2004 at 10:29:29AM -0500, Bagalkote, Sreenivas wrote:
> I agree. The sysfs method would have been the most logical way of doing it.
> But then application becomes sysfs dependent. We really cannot do that.

And we cannot add more ioctl interfaces.

