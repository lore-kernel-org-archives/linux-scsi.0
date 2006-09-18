From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Patch] SCSI statistics
Date: Mon, 18 Sep 2006 23:28:32 +0200
Message-ID: <1158614913.3182.78.camel@laptopd505.fenrus.org>
References: <1158578439.3060.50.camel@dyn-9-152-230-71.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36809 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751206AbWIRV2w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 17:28:52 -0400
In-Reply-To: <1158578439.3060.50.camel@dyn-9-152-230-71.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke <mp3@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2006-09-18 at 13:20 +0200, Martin Peschke wrote:
> This patch makes the SCSI mid layer report statistics data, i.e. request
> sizes, request latencies, request results and queue utilisation.
> For sample output please see below. This data is only gathered if these
> statistics have been enabled by users at run time (default is off).
> 
> It is crucial (for us) to be able to look at such kernel level data in
> case of customer situations. It allows us to determine what kind of
> requests might be involved in performance situations. This information
> helps to understand whether one faces a device issue or a Linux issue.
> Not being able to tap into performance data is regarded as a big minus
> by some enterprise customers, who are reluctant to use Linux SCSI
> support or Linux.
> 
> Patch is against 2.6.18-rc6-mm2, as it requires the statistics
> infrastructure patches.


wouldn't this be nicer as a block level functionality?

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com

