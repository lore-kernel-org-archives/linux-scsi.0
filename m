From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] Don't retry SG_IO (REQ_BLOCK_PC) commands.
Date: Fri, 21 Nov 2003 08:26:51 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031121082651.A8065@beaverton.ibm.com>
References: <20031120085555.A20609@beaverton.ibm.com> <20031120181543.GA3728@beaverton.ibm.com> <20031120191651.GE1106@suse.de> <20031120135123.A2366@beaverton.ibm.com> <20031121101728.GI1106@suse.de> <1069418912.1931.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:37762 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264369AbTKUQ1C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2003 11:27:02 -0500
Content-Disposition: inline
In-Reply-To: <1069418912.1931.5.camel@mulgrave>; from James.Bottomley@SteelEye.com on Fri, Nov 21, 2003 at 06:48:32AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James -

I don't think we are going to resolve the setting and use of the fast fail
flag in the immediate future.

Can you push the patch?

Jens are you OK with the patch?

-- Patrick Mansfield
