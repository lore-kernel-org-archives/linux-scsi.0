From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] Alter the scsi_add_device() API to conform to what users
 expect
Date: Sat, 10 Sep 2005 20:24:19 +0200
Message-ID: <432324D3.2040208@s5r6.in-berlin.de>
References: <1126374249.4813.54.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:24045 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932284AbVIJSYk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Sep 2005 14:24:40 -0400
In-Reply-To: <1126374249.4813.54.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
...
> -	struct scsi_device *sdev;
> +	int error;
...

Side note: The most recent sbp2 at svn.linux1394.org (which is not in 
Linus' tree yet and probably also not in -mm) needs a different approach 
because the sdev is required in sbp2's .remove hook later. I will submit 
an according update to linux1394-devel when the time is rife.
-- 
Stefan Richter
-=====-=-=-= =--= -=-=-
http://arcgraph.de/sr/
