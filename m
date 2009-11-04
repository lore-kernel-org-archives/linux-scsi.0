From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Wed, 04 Nov 2009 15:48:02 +0100
Message-ID: <4AF19422.1010800@s5r6.in-berlin.de>
References: <4F2B1A2459C7AD4D96A23CE911C352CB1E914C889D@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:52501 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030AbZKDOsI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2009 09:48:08 -0500
In-Reply-To: <4F2B1A2459C7AD4D96A23CE911C352CB1E914C889D@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Penchala Narasimha Reddy Chilakala, TLS-Chennai" <narasimhareddyc@hcl.in>
Cc: James Bottomley <James.Bottomley@suse.de>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

Penchala Narasimha Reddy Chilakala, TLS-Chennai wrote:
> Yes, you are right that the up() is used in 3 places and down_trylock,
> down_interruptible in one place each, but we need to do other changes
> like when we return a value ERESTATSYS from that particular function,
> the value will be checked in many places to take appropriate action
> and fibptr->done also checked in some other places. Considering all
> these, I mentioned that we need to modify the code in lot places.

I disagree with this analysis.  I am only talking about the type of
struct fib.event_wait which very probably should be a struct completion
or wait_queue_head_t.

> I hope you understand.

If and why you as author and submitter of the short term fix are also
interested in a real long term fix or not is _entirely_ up to you, or
anybody else who works with the aacraid driver.  If I had this hardware
myself I would send a proposed conversion patch instead of comments what
other people could do.  :-)
-- 
Stefan Richter
-=====-==--= =-== --=--
http://arcgraph.de/sr/
