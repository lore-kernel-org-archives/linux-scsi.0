From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH/RFT] mode sense madness always use page 8
Date: Thu, 30 Oct 2003 10:25:28 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031030102528.A7468@beaverton.ibm.com>
References: <Pine.LNX.4.44L0.0310301004010.852-100000@ida.rowland.org> <1067531731.4250.11.camel@pathost1.iomegacorp.com> <20031030091808.A6781@beaverton.ibm.com> <1067535485.6411.42.camel@pathost1.iomegacorp.com> <20031030100501.A7250@beaverton.ibm.com> <1067537697.1133.131.camel@ronald.kuetemeier.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:5330 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262745AbTJ3S0i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 13:26:38 -0500
Content-Disposition: inline
In-Reply-To: <1067537697.1133.131.camel@ronald.kuetemeier.com>; from ronald@kuetemeier.com on Thu, Oct 30, 2003 at 11:14:57AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Ronald Kuetemeier <ronald@kuetemeier.com>
Cc: Pat LaVarre <p.lavarre@ieee.org>, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com

On Thu, Oct 30, 2003 at 11:14:57AM -0700, Ronald Kuetemeier wrote:
> Patrick,
> should I leave the prev. scsi.h patch in or take it out before this try?
> BTW: I will be off for the rest of the week, but will give you feedback
> on this one today ( I hope).
> Ronald

Leave it in, it will hopefully not matter. I ran without it, mainly so I
could trivially get a clean patch, I am not good at managing patch
collections.

-- Patrick Mansfield
