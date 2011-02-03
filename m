From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Open-FCoE] [v2 PATCH 4/5] bnx2fc: Broadcom FCoE Offload driver
 submission - part 2
Date: Wed, 02 Feb 2011 22:16:11 -0600
Message-ID: <4D4A2C0B.1080804@cs.wisc.edu>
References: <1293170555.4676.574.camel@ltsjc-bprakash2.corp.ad.broadcom.com>	<4D316634.5030300@cs.wisc.edu>	<1295311066.3536.105.camel@ltsjc-bprakash2.corp.ad.broadcom.com>	<4D4922BE.40907@cs.wisc.edu>	<1296704558.268.552.camel@LTLNR-SJCE10.corp.ad.broadcom.com> <4D4A29A1.7010105@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42953 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758Ab1BCEPs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Feb 2011 23:15:48 -0500
In-Reply-To: <4D4A29A1.7010105@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>
Cc: "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/02/2011 10:05 PM, Mike Christie wrote:
> On 02/02/2011 09:42 PM, Bhanu Gollapudi wrote:
>>>
>>> Actually you do not have to wait for the scsi eh to run, right. It
>>> looks
>>> like bnx2fc would log out the port, which ends up calling
>>> fc_remote_port_delete and that would cause the fc timed out function
>>> to
>>> return BLK_EH_RESET_TIMER to prevent the scsi eh from running. Is
>>> that
>>> right? That type of eh strategy behavior seems like something you
>>> want
>>> to sync up with libfc or the fc class so all drivers do something
>>> similar.
>>
>> As per FCP-4, if the ABTS times out, we will have to explicitly LOGO the
>
> What section is that in?
>

Nevermind. I found it. Just a sec.
