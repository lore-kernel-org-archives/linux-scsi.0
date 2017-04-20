From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: commit 1b6ac5e3f "fnic: Using rport->dd_data to check rport online instead of rport_lookup."
Date: Wed, 19 Apr 2017 22:27:04 -0400
Message-ID: <yq137d3reyv.fsf@oracle.com>
References: <58DDA49B.6000300@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19345 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966736AbdDTC1O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2017 22:27:14 -0400
In-Reply-To: <58DDA49B.6000300@oracle.com> (Joe Jin's message of "Fri, 31 Mar
        2017 08:36:43 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: satishkh@cisco.com
Cc: Joe Jin <joe.jin@oracle.com>, linux-scsi@vger.kernel.org

Joe Jin <joe.jin@oracle.com> writes:

> My customer hit below error when issue LIP to fnic controller:
>
> [94702.898408] sd 2:0:4:1: [sdx] tag#1 FAILED Result:
> hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [94702.898416] sd 2:0:4:1: [sdx] tag#1 CDB: Write(10) 2a 00 04 56 c0 08 00 00 08 00
> [94702.898420] blk_update_request: I/O error, dev sdx, sector 72794120
> [94702.898455] sd 2:0:4:10: [sdy] tag#2 FAILED Result:
> hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [94702.898459] sd 2:0:4:10: [sdy] tag#2 CDB: Read(10) 28 00 00 00 08 a8 00 00 02 00
> [94702.898462] blk_update_request: I/O error, dev sdy, sector 2216
>
> Looked at all changes of fnic I found it caused by commit 1b6ac5e3f "fnic: 
> Using rport->dd_data to check rport online instead of rport_lookup.", a 
> question is why changed state check from RPORT_ST_DELETE to RPORT_ST_READY
> here?

Satish?

-- 
Martin K. Petersen	Oracle Linux Engineering
