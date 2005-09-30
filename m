From: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Subject: RE: Re: accessing the scsi disk from a kernel module
Date: Fri, 30 Sep 2005 12:00:55 -0400
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57060CD205@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61896 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1030350AbVI3QBX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Sep 2005 12:01:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Karthik Sarangan' <karthiks@cdac.in>, Fawad Lateef <fawadlateef@gmail.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

 
>>
>I dont want the buffer cache of the block device interfering.
>
>Basically I require to read/write data (without being cached 
>or copied into intermediate kernel buffers) to scsi disk from 
>a kernel module.
>

This is exactly what "raw" does. (Do man raw)
