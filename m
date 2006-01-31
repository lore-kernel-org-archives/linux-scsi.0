From: Brian King <brking@us.ibm.com>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.16-rc1
Date: Tue, 31 Jan 2006 17:18:26 -0600
Message-ID: <43DFF042.1050809@us.ibm.com>
References: <1138741016.3307.20.camel@mulgrave>	 <43DFD316.3080100@us.ibm.com> <1138748990.3307.33.camel@mulgrave>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44442 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932078AbWAaXS2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2006 18:18:28 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k0VNIRd9018210
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jan 2006 18:18:27 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k0VNISAw172522
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jan 2006 18:18:28 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k0VNIRx7027951
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jan 2006 18:18:27 -0500
In-Reply-To: <1138748990.3307.33.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Tue, 2006-01-31 at 15:13 -0600, Brian King wrote:
>> Any reason the other sg patch I submitted didn't get pushed?
> 
> Er ... I didn't notice it go by and no-one told me?
> 
>> http://marc.theaimsgroup.com/?l=linux-scsi&m=113753907627483&w=2
>>
>> I was hoping to see this one go into the rc fixes, since without
>> it ipr's RAID configuration tools do not work.
> 
> In theory, it only affects the sg path, the path via the ULD device node
> should already be fixed, so any management tool could use the sd (or st
> or sr) node instead ... you probably want to do that anyway to avoid
> mapping issues between the sg and sd nodes.

I already use the sd node when I can in ipr's RAID management tool, but for
physical disks in RAID arrays and for the RAID adapter itself, only
sg gets attached, so I have to use sg.

Brian


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
