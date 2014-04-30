From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v1.0 1/11] arcmsr: Revise interrupt service routine
 relate function
Date: Wed, 30 Apr 2014 16:56:04 +0000
Message-ID: <1398876964.2182.13.camel@dabdike.int.hansenpartnership.com>
References: <1398850855.1769.11.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:43698 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaD3Q4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Apr 2014 12:56:30 -0400
In-Reply-To: <1398850855.1769.11.camel@localhost>
Content-Language: en-US
Content-ID: <7857E40DF4806C4CB357F2CA470CF033@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ching2048@areca.com.tw" <ching2048@areca.com.tw>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>, "thenzl@redhat.com" <thenzl@redhat.com>

On Wed, 2014-04-30 at 17:40 +0800, ching wrote:
> From: Ching<ching2048@areca.com.tw>
> 
> Rewrite interrupt service routine relate function to fix command
> timeout on controller very heavy loading.

OK, so I think you've confused us a bit.  This looks to be an update of
your previous v1.4 patch set, yet it's now called v1.0?

Could you please include a cover letter as patch 0/x like you see
everyone else doing on the list?  In this cover letter can you tell us
what the disposition of the previous feedback is and what other changes
have you done? You didn't reply to any of the comments, have have you
fixed them?  It's very dispiriting to review 11 patches, give feedback
and not hear anything ... and then have to review an even longer set of
patches just to see if anything was done about your previous comments.

The less interactive you are with reviews, the less chance there is that
people will review updates ... without external reviewers, you go on a
very long backlog of things I have to review before the patches get in.

James

