From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: qla2xxx tcq question/bug
Date: Fri, 09 Jul 2004 17:12:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40EF345E.7040207@us.ibm.com>
References: <40EF2697.20804@us.ibm.com> <20040709234644.GB14787@praka.san.rr.com> <20040709235443.GA14953@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:42399 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S266033AbUGJAMd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jul 2004 20:12:33 -0400
In-Reply-To: <20040709235443.GA14953@praka.san.rr.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>
Cc: andrew.vasquez@qlogic.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

Andrew Vasquez wrote:
> On Fri, 09 Jul 2004, Andrew Vasquez wrote:
> 
> 
>>On Fri, 09 Jul 2004, Mike Christie wrote:
>>
>>
>>>Should the qla2xx driver be calling
>>>scsi_activate_tcq/scsi_populate_msg for devices that support tags,
>>
>>I've taken a look through the ipr code (the only visible caller of
>>scsi_populate_tag_msg()) -- looks like the qla driver has some
>>problems here.
>>
> 
> 
> BTW: 53c700.c appears to be the only scsi driver which calls
> scsi_activate_tcq()???

And several other drivers like lpfc and qlogicfc do it your way.


-- 
Mike Christie
mikenc@us.ibm.com

