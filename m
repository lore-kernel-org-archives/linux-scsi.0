From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [v2 PATCH 0/4] bnx2fc version 1.0.11
Date: Tue, 22 May 2012 09:45:14 +0100
Message-ID: <1337676314.28492.3.camel@dabdike.int.hansenpartnership.com>
References: <1335306364-31449-1-git-send-email-bprakash@broadcom.com>
	 <4FBA6AD8.5060703@broadcom.com>
	 <1337623588.16400.5.camel@dabdike.int.hansenpartnership.com>
	 <4FBA8AD6.70107@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47769 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754756Ab2EVIpS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 May 2012 04:45:18 -0400
In-Reply-To: <4FBA8AD6.70107@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>

On Mon, 2012-05-21 at 11:35 -0700, Bhanu Prakash Gollapudi wrote:
> On 5/21/2012 11:06 AM, James Bottomley wrote:
> > On Mon, 2012-05-21 at 09:18 -0700, Bhanu Prakash Gollapudi wrote:
> >> On 4/24/2012 3:26 PM, Bhanu Prakash Gollapudi wrote:
> >>
> >> James, can you please include this patch set in the next round of 3.4+
> >> merge window?
> >
> > I was waiting for you to respond to Mike Christie's comment about using
> > list_for_each_entry_safe() or list_entry().
> 
> James, I responded to Mike Christie's comment. Here is the link for the 
> thread - http://marc.info/?l=linux-scsi&m=133643754200805&w=2.

Ah, OK, you broke threading, which is why I didn't get this.  You need
to reply to the message on the list.  Your reply has:

References: <4FA85912.2030800@broadcom.com>
In-reply-to: <4FA85912.2030800@broadcom.com>

But the actual message is:

Message-id: <4FA39836.3070907@cs.wisc.edu>

Evolution matches threads by the in-reply-to fields.

James


