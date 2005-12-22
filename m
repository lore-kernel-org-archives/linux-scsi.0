From: Dax Kelson <dax@gurulabs.com>
Subject: Re: ETA for Areca RAID driver (arcmsr) in mainline?
Date: Thu, 22 Dec 2005 12:31:34 -0700
Message-ID: <1135279895.19320.24.camel@mentorng.gurulabs.com>
References: <1135228831.4122.15.camel@mentorng.gurulabs.com>
	 <1135229681.439.23.camel@mindpipe> <200512220917.41494.oliver@neukum.org>
	 <1135239601.2940.5.camel@laptopd505.fenrus.org>
	 <20051222052443.57ffe6f9.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gurulabs.com ([67.137.148.7]:50124 "EHLO mail.gurulabs.com")
	by vger.kernel.org with ESMTP id S1030261AbVLVTbL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Dec 2005 14:31:11 -0500
In-Reply-To: <20051222052443.57ffe6f9.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Arjan van de Ven <arjan@infradead.org>, oliver@neukum.org, rlrevell@joe-job.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 2005-12-22 at 05:24 -0800, Andrew Morton wrote:

> Yes, there are lots of stylistic and API-usage issues with the driver and
> it needs someone to fix them all up.  Unfortunately the original
> developer's English is very poor and he's obviously quite unfamiliar with
> how Linux development happens.
> 
> This is all resolveable - it just needs someone to get down and work with
> Erich on knocking the driver into shape.  But as yet, nobody has stepped up
> to do that work.
> 
> And yes, the driver does apparently work.

I emailed Areca and got a response that indicated they didn't know about
the remaining stylistic and API-usage issues with the driver.

If someone could spell it out to them what exactly needs to to be fixed
for it to get merged into the Linus tree, they sound eager to do the
work.

The current driver does indeed work. Last night I copied several hundred
gigabytes of data using the driver.

Dax Kelson
Guru Labs

