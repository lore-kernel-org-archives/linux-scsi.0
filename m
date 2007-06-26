From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: qla2xxx errors? (2.6.19)
Date: Tue, 26 Jun 2007 05:46:40 -0700
Message-ID: <20070626124640.GO14570@plap.qlogic.org>
References: <20070610100011.GG5705@digitus> <20070612174854.GD12266@plap.qlogic.org> <20070621214143.GC29237@digitus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:50249 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbXFZMqo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jun 2007 08:46:44 -0400
Content-Disposition: inline
In-Reply-To: <20070621214143.GC29237@digitus>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Csillag Tamas <cstamas@digitus.itk.ppke.hu>
Cc: linux-scsi@vger.kernel.org

On Thu, 21 Jun 2007, Csillag Tamas wrote:

> Hi Andrew,
> 
> On 06/12, Andrew Vasquez wrote:
> ...
> > I can setup somthing similar locally, I take it you are writing
> > directly some some lun exported off the DS400, and not using DM?
> ...
> 
> Do you have any results? Does the information I sent regarding my
> system helped?
> 
> Please tell me if you need more information or anything that can help.

The initial logs don't indicate any 'notable' driver issues during the
I/O test.  Concurrently, we've been unable to reproduce on similar
storage along with other array devices.  I've escalated this to our
formal support group (which should be in contact with you shortly) in
hopes of triaging this further and getting resolution.

Regards,
Andrew Vasquez
