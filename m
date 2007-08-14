From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 2/6] mpt fusion: Usage of high priority request FIFO to send task management commands
Date: Tue, 14 Aug 2007 10:17:32 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D709166CB@NAMAIL4.ad.lsil.com>
References: <20070814103840.GB9944@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60215 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757604AbXHNQRj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2007 12:17:39 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070814103840.GB9944@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Tuesday, August 14, 2007 4:39 AM, Prakash, Sathya wrote: 
> Added support for sending the task management requests 
> through High priority 
> request FIFO instead of Doorbell writes when firmware support 
> High priority
> FIFO.
> 
> signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
> ---

ACK
