From: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Subject: RE: How to add/drop SCSI drives from within the driver?
Date: Tue, 4 Jan 2005 12:25:54 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570230CAD3@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:31377 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261802AbVADRd6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2005 12:33:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: Matt Domsch <Matt_Domsch@Dell.com>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, brking@us.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, bunk@fs.tum.de, Andrew Morton <akpm@osdl.org>, "Ju, Seokmann" <sju@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>

>
>On Mon, 2005-01-03 at 18:02 -0500, Bagalkote, Sreenivas wrote:
>> o    Everybody understands that as long as the SCSI 
>scan/rescan is triggered
>> by 
>> the management app, there is no getting around knowing HCTL 
>mapping. The app
>> must know the HCTL quad of a logical drive.
>
>Actually, if that's all you're trying to do, what about
>
>echo '- - -' > /sys/class/scsi_host/host<n>/scan
>
>That'll trigger a rescan of the entire card and the device 
>will be found
>and added?
>

A minor point is that an application should ideally force scan only those
drives
that it has added. But more importantly, this will not help an application
to delete
the drives. Correct?

Sreenivas
