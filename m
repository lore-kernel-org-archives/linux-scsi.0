From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Requested changes for the SCSI error handler
Date: Tue, 8 Jun 2004 10:19:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040608171925.GC4757@us.ibm.com>
References: <1086122775.2061.87.camel@mulgrave> <Pine.LNX.4.44L0.0406041655550.843-100000@ida.rowland.org> <20040604232344.GA3214@us.ibm.com> <1086711994.2105.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:23235 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S265258AbUFHRTQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jun 2004 13:19:16 -0400
Content-Disposition: inline
In-Reply-To: <1086711994.2105.18.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> So, what about Alan's approach using a single flag to give the LLD
> control, but give it control for both the host and bus resets?
> 

This sounds good.

-andmike
--
Michael Anderson
andmike@us.ibm.com

