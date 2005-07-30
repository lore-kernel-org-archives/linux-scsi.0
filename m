From: Alex Aizman <itn780@yahoo.com>
Subject: Re: [ANNOUNCE 0/7] Open-iSCSI/Linux-iSCSI-5 High-Performance	Initiator
Date: Sat, 30 Jul 2005 11:36:22 -0700
Message-ID: <42EBC8A6.7030403@yahoo.com>
References: <429E15CD.2090202@yahoo.com> <1122744762.5055.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp011.mail.yahoo.com ([216.136.173.31]:14720 "HELO
	smtp011.mail.yahoo.com") by vger.kernel.org with SMTP
	id S263101AbVG3Sga (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Jul 2005 14:36:30 -0400
In-Reply-To: <1122744762.5055.10.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

James Bottomley wrote:
> On Wed, 2005-06-01 at 13:08 -0700, Alex Aizman wrote:
> 
>>This is open-iscsi/linux-iscsi-5 Initiator. This submission is ready for
>>inclusion into mainline kernel.
> 
> 
> OK, I tried to put this into scsi-misc.
> 
> FIB has taken your netlink number, so I changed it to 32
> 

OK. Hopefully that'll remain.

> __nlm_put() has had an updated prototype, which I can fix (although I'm
> not sure you're supposed to be using this function...)
> 
> I can't fix up the compile errors in iscsi_tcp.c:
> 

Yes, the 06/01 submission was for 2.6.11. It will not compile.

Here's the latest development tarball 0.3rc7:

http://www.open-iscsi.org/bits/open-iscsi-0.3rc7-383.tar.gz
(This, as well as all the previous code drops can be downloaded from 
http://www.open-iscsi.org/index.html#download.)

Will work on producing a new patchset for 2.6.13. The only pending item now is 
code style cleanup.

Changelog, etc. Monday 08/01 is the latest.

>   CC [M]  drivers/scsi/iscsi_tcp.o
> drivers/scsi/iscsi_tcp.c: In function `iscsi_hdr_extract':
> drivers/scsi/iscsi_tcp.c:160: warning: implicit declaration of function
> `iscsi_cnx_error'
> drivers/scsi/iscsi_tcp.c:161: error: `ISCSI_ERR_PDU_GATHER_FAILED'
> undeclared (first use in this function)
> drivers/scsi/iscsi_tcp.c:161: error: (Each undeclared identifier is
> reported only once
> drivers/scsi/iscsi_tcp.c:161: error: for each function it appears in.)
> drivers/scsi/iscsi_tcp.c: In function `iscsi_tcp_state_change':
> drivers/scsi/iscsi_tcp.c:1005: error: `ISCSI_ERR_CNX_FAILED' undeclared
> (first use in this function)
> drivers/scsi/iscsi_tcp.c: In function `iscsi_sendhdr':
> drivers/scsi/iscsi_tcp.c:1092: error: `ISCSI_ERR_CNX_FAILED' undeclared
> (first use in this function)
> drivers/scsi/iscsi_tcp.c: In function `iscsi_sendpage':
> drivers/scsi/iscsi_tcp.c:1141: error: `ISCSI_ERR_CNX_FAILED' undeclared
> (first use in this function)
> drivers/scsi/iscsi_tcp.c: In function `iscsi_data_xmit_more':
> drivers/scsi/iscsi_tcp.c:1707: error: `STOP_CNX_RECOVER' undeclared
> (first use in this function)
> drivers/scsi/iscsi_tcp.c: At top level:
> [...]
> 
> Do you have an updated driver that will work in the current tree?
> 
> Thanks,
> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

