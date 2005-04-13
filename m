From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: PATCH [6/5]  qla2xxx: update version :)
Date: Wed, 13 Apr 2005 15:57:08 -0500
Message-ID: <1113425828.4933.39.camel@mulgrave>
References: <20050413205007.GA14857@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:39834 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261177AbVDMU5W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2005 16:57:22 -0400
In-Reply-To: <20050413205007.GA14857@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-04-13 at 13:50 -0700, Andrew Vasquez wrote:
> -#define QLA2XXX_VERSION      "8.00.02b4-k"
> +#define QLA2XXX_VERSION      "8.00.02b5-k"

so, erm, removing about 4,000 lines of code and embracing a new
transport infrastructure doesn't even warrant a minor minor number
change in the driver ... ?

James


