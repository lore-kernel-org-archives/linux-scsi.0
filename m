From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] add execute_in_process_context() API
Date: Wed, 08 Feb 2006 13:51:50 +0100
Message-ID: <43E9E966.9060003@s5r6.in-berlin.de>
References: <1139342419.6065.8.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:40163 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1161082AbWBHMqy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 07:46:54 -0500
In-Reply-To: <1139342419.6065.8.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

James Bottomley wrote:
> SCSI needs this for our scheme to avoid executing generic device release
> calls from interrupt context (SCSI patch using this to follow).

Shouldn't we rather fix the SCSI low level drivers or SCSI transport 
layers to trigger device releases only from process context? (Instead of 
SCSI core transparently falling back to a workqueue, that is.)

I know only one of these drivers, hence I don't know which are actually 
affected and how much work that would be.
-- 
Stefan Richter
-=====-=-==- --=- -=---
http://arcgraph.de/sr/

