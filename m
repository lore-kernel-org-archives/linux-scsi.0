From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH [5/15] qla2xxx:  SG tablesize update
Date: 14 Mar 2004 09:49:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079275768.2022.1.camel@mulgrave>
References: <20040314082444.GA3416@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:400 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263370AbUCNOtk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 09:49:40 -0500
In-Reply-To: <20040314082444.GA3416@linux.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-03-14 at 03:24, Andrew Vasquez wrote:
> -	.sg_tablesize		= SG_ALL,
> +	.sg_tablesize		= 32,

Are you sure you want to do this?  It limits the maximum transfer size
per command to 128k (on x86) which is a bit small for FC.

James


