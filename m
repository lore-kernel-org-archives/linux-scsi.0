From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH/RESEND 2/2] Hard disk S3 resume time optimization
Date: Fri, 06 Sep 2013 08:10:34 -0700
Message-ID: <1378480234.2063.16.camel@dabdike.int.hansenpartnership.com>
References: <20130906004425.GA31998@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59770 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753943Ab3IFPKg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 11:10:36 -0400
In-Reply-To: <20130906004425.GA31998@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: todd.e.brandt@linux.intel.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, tj@kernel.org

On Thu, 2013-09-05 at 17:44 -0700, Todd E Brandt wrote:
> Part 2 of the hard disk resume optimization patch, this one applies
> to the scsi subsystem.

This is a horrible patch description, it won't tell the next reader
anything about what is going on and why.  Give the patches two separate
summaries and refer back by summary explaining what this one does.

Also, having two code paths do the same thing is always a bad idea:
someone will update one and not the other.  sd_resume() should be come
sd_resume_async(); wait for async event

James


