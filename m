From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: How to add/drop SCSI drives from within the driver?
Date: Thu, 9 Dec 2004 18:03:08 -0600
Message-ID: <20041210000308.GA5146@lists.us.dell.com>
References: <0E3FA95632D6D047BA649F95DAB60E570230CA9C@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linux.us.dell.com ([143.166.224.162]:43613 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S261641AbULJAEU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 19:04:20 -0500
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570230CA9C@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: "'brking@us.ibm.com'" <brking@us.ibm.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, 'Andrew Morton' <akpm@osdl.org>, "Ju, Seokmann" <sju@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>

On Thu, Dec 09, 2004 at 06:37:19PM -0500, Bagalkote, Sreenivas wrote:
> I am submitting the final patch that incorporates Matt's suggestions.
> +} __attribute__ ((packed));

I believe, per the discussion, that this was unnecessary and possibly
even incorrect.  Please repost one more time with this removed.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
