From: Brian King <brking@us.ibm.com>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.16-rc1
Date: Tue, 31 Jan 2006 15:13:58 -0600
Message-ID: <43DFD316.3080100@us.ibm.com>
References: <1138741016.3307.20.camel@mulgrave>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:7648 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751493AbWAaVOB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2006 16:14:01 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k0VLE0ma013443
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jan 2006 16:14:00 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k0VLE0YB179772
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jan 2006 16:14:00 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k0VLDxME025666
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jan 2006 16:14:00 -0500
In-Reply-To: <1138741016.3307.20.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> These are mainly driver bug fixes and updates.

> Brian King:
>   o Prevent scsi_execute_async from guessing cdb length

James,

Any reason the other sg patch I submitted didn't get pushed?

http://marc.theaimsgroup.com/?l=linux-scsi&m=113753907627483&w=2

I was hoping to see this one go into the rc fixes, since without
it ipr's RAID configuration tools do not work.

Thanks,

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
