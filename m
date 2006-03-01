From: "Asgeir Eiriksson" <asgeir_eiriksson@hotmail.com>
Subject: Re: SATA on mptsas performance
Date: Wed, 01 Mar 2006 09:55:54 -0800
Message-ID: <BAY107-F31DBAB4CFEF7B8F61B3719E6F40@phx.gbl>
References: <44051548.9090408@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bay107-f31.bay107.hotmail.com ([64.4.51.41]:62736 "EHLO
	hotmail.com") by vger.kernel.org with ESMTP id S1030189AbWCAR4D
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Mar 2006 12:56:03 -0500
In-Reply-To: <44051548.9090408@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, mirko.benz@web.de
Cc: linux-scsi@vger.kernel.org

Doug

I realize that your 10b8b arithmetic was probably meant to be approximate, 
but I'd still like to point out that 10G Ethernet technology uses the 8b 
number when quoting bandwidth whereas e.g. IB quotes the 10b number (let's 
refer to this as data rate vs. signaling rate).

For example: so called 10Gbps IB has a data rate limit of 8Gbps, whereas 
10GE has a data rate lmit of 10Gbps (countinting TCP/IP headers as part of 
the BW).

For CX-4 copper cable (Infiiniband connectors and cable) the rate of the 
serdes used are actually different for the two technologies with IB having 4 
lanes at 2.5GHz whereas 10G Ethernet has 4 lanes at 3.125GHz, leading again 
to 8Gbps IB vs. 10Gbps Ethernet data rate bandwidth.

Regards,

Asgeir Eiriksson
Chelsio Communications Inc.

>From: Douglas Gilbert <dougg@torque.net>
>Reply-To: dougg@torque.net
>To: Mirko Benz <mirko.benz@web.de>
>CC: linux-scsi@vger.kernel.org
>Subject: Re: SATA on mptsas performance
>Date: Tue, 28 Feb 2006 22:30:16 -0500
>
...
>
>BTW since SAS uses "10b8b" encoding (as do IB,
>FC, SATA, PCIe, 10 gigabit ethernet on copper, etc) which
>encodes 8 data bits into 10 bits on the wire then one
>can flip between "<n> MB/sec" and "(<n> * 10) Mb/sec". The
>capitalization (or not) of the "B" is obviously significant.
>Perhaps somebody from a SAS vendor company could tell us how
>much data one can really send down a 3 Gb/sec SAS/STP
>connection under optimum conditions.
>
>
>Doug Gilbert
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


