From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: qla2xxx tcq question/bug
Date: Fri, 09 Jul 2004 17:05:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40EF32D6.5010300@us.ibm.com>
References: <40EF2697.20804@us.ibm.com> <20040709234644.GB14787@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:42439 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S266018AbUGJAF7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jul 2004 20:05:59 -0400
In-Reply-To: <20040709234644.GB14787@praka.san.rr.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>
Cc: andrew.vasquez@qlogic.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

Andrew Vasquez wrote:
> I've taken a look through the ipr code (the only visible caller of
> scsi_populate_tag_msg()) -- looks like the qla driver has some
> problems here.

53c700.c uses it too.

The ipr driver actaully has a bug, but Brian was fixing it.

Thanks,

-- 
Mike Christie
mikenc@us.ibm.com

