From: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Subject: RE: [PATCH]: megaraid 2.20.4: Fixes a data corruption bug
Date: Fri, 1 Oct 2004 16:32:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570230C986@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:38101 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266574AbUJAUkc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2004 16:40:32 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: "Mukker, Atul" <Atulm@lsil.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, 'Andrew Morton' <akpm@osdl.org>, "'Matt_Domsch@dell.com'" <Matt_Domsch@dell.com>, "Ju, Seokmann" <sju@lsil.com>

Without CONFIG_COMPAT around them, I get "unresolved symbol"
for (un)register_ioctl32_conversion while loading the module.

Thanks,
Sreenivas

>-----Original Message-----
>From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
>Sent: Friday, October 01, 2004 4:24 PM
>To: Bagalkote, Sreenivas
>Cc: Mukker, Atul; 'linux-kernel@vger.kernel.org';
>'linux-scsi@vger.kernel.org'; 'bunk@fs.tum.de'; 'Andrew Morton';
>'Matt_Domsch@dell.com'; Ju, Seokmann
>Subject: RE: [PATCH]: megaraid 2.20.4: Fixes a data corruption bug
>
>
>On Fri, 2004-10-01 at 16:08, Bagalkote, Sreenivas wrote:
>> The submitted previous version of megaraid (2.20.3.1) had 
>> register_ioctl32_conversion & unregister_ioctl32_conversion 
>> defined to empty statements if CONFIG_COMPAT was _not_
>> defined.
>
>
>> But I think the preferred way was to have the occurances of 
>> (un)register_ioctl32_conversion in the code surrounded by 
>> #ifdef CONFIG_COMPAT ... #endif directly. In the kernel source
>> only register_ioctl32_conversion has these #ifdef .. #endif. The
>> unregister_ioctl32_conversion doesn't.
>
>Actually, because of the way linux/ioctl32 defines these, the #ifdef
>CONFIG_COMPAT is unnecessary even around register_ioctl32_...
>
>James
>
>
