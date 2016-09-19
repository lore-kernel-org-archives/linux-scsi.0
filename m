From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RESEND] [PATCH 1/1] ses: Retry UNIT ATTENTION for receive
 diagnostics
Date: Mon, 19 Sep 2016 09:20:34 -0700
Message-ID: <1474302034.2398.4.camel@HansenPartnership.com>
References: <20160916210607.054BF124047@b01ledav002.gho.pok.ibm.com>
         <yq1eg4fann1.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49128 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751672AbcISQUj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Sep 2016 12:20:39 -0400
In-Reply-To: <yq1eg4fann1.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, krisman@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, stable@vger.kernel.org

On Mon, 2016-09-19 at 11:57 -0400, Martin K. Petersen wrote:
> > > > > > "Brian" == Brian King <brking@linux.vnet.ibm.com> writes:
> 
> Brian> If the ses driver receives a UNIT ATTENTION when issuing a
> Brian> receive diagnostics while probing a SES device, it fails to
> Brian> attach with messages such as:
> 
> Brian> scsi 1:0:7:0: Failed to get diagnostic page 0x8000002 scsi
> Brian> 1:0:7:0: Failed to bind enclosure -19
> 
> Brian> Fix this by eating unit attentions for these commands.
> 
> James?

It seems to me that UA handling should be a part of scsi_execute_req
(and scsi_execute) ... that is unless anyone can find a caller that
would actually be interested.  I've been looking but haven't found one
so far.

James

