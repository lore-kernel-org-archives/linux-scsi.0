From: Brian King <brking@us.ibm.com>
Subject: Re: qla2xxx tcq question/bug
Date: Fri, 09 Jul 2004 20:49:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40EF4B1B.4040806@us.ibm.com>
References: <40EF2697.20804@us.ibm.com> <20040709234644.GB14787@praka.san.rr.com> <40EF32D6.5010300@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:48085 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S266073AbUGJBtd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jul 2004 21:49:33 -0400
In-Reply-To: <40EF32D6.5010300@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: Andrew Vasquez <praka@users.sourceforge.net>, andrew.vasquez@qlogic.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Christie wrote:
> Andrew Vasquez wrote:
> 
>> I've taken a look through the ipr code (the only visible caller of
>> scsi_populate_tag_msg()) -- looks like the qla driver has some
>> problems here.
> 
> 
> 53c700.c uses it too.
> 
> The ipr driver actaully has a bug, but Brian was fixing it.

I'm in the process of adding the scsi_activate_tcq/scsi_deactivate_tcq 
calls to the ipr driver, as Mike mentioned. I figured I would also 
update the API doc to clarify the usage, using the 53c000.c driver as 
the model.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

