From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: program scsi_unique_id is using a deprecated SCSI ioctl,
	please convert it to SG_IO
Date: Mon, 28 Mar 2005 09:39:23 -0600
Message-ID: <1112024363.5531.5.camel@mulgrave>
References: <20050328103324.GB28175@logos.cnet>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:61648 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261899AbVC1Pjc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2005 10:39:32 -0500
In-Reply-To: <20050328103324.GB28175@logos.cnet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-03-28 at 07:33 -0300, Marcelo Tosatti wrote:
> You probably already know about this, but just in case:
> 
> v2.6.12-rc1 yields
> 
> program scsi_unique_id is using a deprecated SCSI ioctl, please convert it to SG_IO

Actually, a lot of programs do this.  Since about 2.6.11 (I think, might
be earlier), the SCSI subsystem has actually begun warning about the use
of ioctls which have been deprecated for a while.

The solution is to fix up the scsi_unique_id program to use SG_IO.

James


