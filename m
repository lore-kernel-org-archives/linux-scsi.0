From: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Subject: RE: How to add/drop SCSI drives from within the driver?
Date: Thu, 9 Dec 2004 19:31:52 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570230CA9D@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:34697 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261555AbULJAjp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2004 19:39:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Matt Domsch' <Matt_Domsch@dell.com>
Cc: "'brking@us.ibm.com'" <brking@us.ibm.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, 'Andrew Morton' <akpm@osdl.org>, "Ju, Seokmann" <sju@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>

>> +} __attribute__ ((packed));
>
>I believe, per the discussion, that this was unnecessary and 
>possibly even incorrect.  Please repost one more time with 
>this removed.
>

Yes, thank you. I will do that. The patch that I submitted earlier
had an one more critical fix. I will separate them into two patches
and submit them as PATCH 1/2 & 2/2 as well.

Thanks,
Sreenivas
LSI Logic
