From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Peripheral qualifier 1 not considered in scsi_probe_and_add_lun
Date: 27 Nov 2003 09:55:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069948509.1837.36.camel@mulgrave>
References: <200311252037.34015.krmurthy@cisco.com>
	<1069773808.2061.6.camel@mulgrave> <200311271849.15241.krmurthy@cisco.com>
	<200311272026.11922.krmurthy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:8199 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264545AbTK0PzS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Nov 2003 10:55:18 -0500
In-Reply-To: <200311272026.11922.krmurthy@cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Krishna Murthy <krmurthy@cisco.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

On Thu, 2003-11-27 at 08:56, Krishna Murthy wrote:
> Shouldn't the same apply for peripheral qualifier 1. This is what the SCSI 
> spec has to say about 1:
> The device server is capable of supporting specified peripheral device type
> on this logical unit. However the physical device is currently not connected 
> to this logical unit.

We handle PQ 1 later, because it indicates a transient connection
condition.  See scsi_add_lun().

James


