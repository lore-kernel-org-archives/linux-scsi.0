From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] SCSI: detect missing data for INQUIRY
Date: Wed, 03 Dec 2008 20:46:23 +0200
Message-ID: <4936D3FF.1040500@panasas.com>
References: <Pine.LNX.4.44L0.0812031315490.2518-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:17486 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751227AbYLCSqa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 13:46:30 -0500
In-Reply-To: <Pine.LNX.4.44L0.0812031315490.2518-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> On Wed, 3 Dec 2008, James Bottomley wrote:
> 
>> On Wed, 2008-12-03 at 12:44 -0500, Alan Stern wrote:
>>> James:
>>>
>>> There hasn't been any feedback on this patch:
>>>
>>> 	http://marc.info/?l=linux-scsi&m=122513368301598&w=2
>>>
>>> It was modified in the way you requested.  Does it need to be revised 
>>> any more?
>> Probably not.  I really dislike a check and retry on something which is
>> theoretically a legal return, but I suppose I can put it in and see if
>> anything breaks.
> 
> It's too bad that the scsi_execute_req() interface loses all 
> information about how much data the device actually sent.  If that 
> information were preserved then it wouldn't be necessary to rely on 
> this not-quite-satisfactory sort of test.
> 
> Alan Stern
> 

Just a comment:
You are the third person this week that wanted residual return from
scsi_execute/scsi_execute_req. Perhaps it's time as come ;)

(This is a TODO for me)

Boaz
