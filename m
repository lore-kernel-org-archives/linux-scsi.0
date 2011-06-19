From: David Dillow <dillowda@ornl.gov>
Subject: Re: [PATCH 1/2] IB/srp: Fix SCSI scanning
Date: Sun, 19 Jun 2011 13:27:49 -0400
Message-ID: <1308504469.14467.5.camel@obelisk.thedillows.org>
References: <201106191348.24122.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:43425 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab1FSSPW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jun 2011 14:15:22 -0400
In-Reply-To: <201106191348.24122.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, Roland Dreier <roland@purestorage.com>

On Sun, 2011-06-19 at 13:48 +0200, Bart Van Assche wrote:
> Avoid that SCSI scanning triggers creation of targets with non-zero
> channel or non-zero id.

Good catch, Bart. How did you find this?

I would like to have a little more meat in the description. What real
problem are we avoiding -- what happens when we get non-zero id/channel?

Based on a quick look at the code -- I don't have ready access to a test
system today -- I'm guessing that we create duplicate devices as a
result of a manual scan?

Signed-off-by: David Dillow <dillowda@ornl.gov>

