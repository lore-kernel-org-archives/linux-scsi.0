From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: program scsi_unique_id is using a deprecated SCSI ioctl,
	please convert it to SG_IO
Date: Mon, 28 Mar 2005 11:35:52 -0600
Message-ID: <1112031352.5531.41.camel@mulgrave>
References: <20050328103324.GB28175@logos.cnet>
	 <1112024363.5531.5.camel@mulgrave>  <20050328123430.GC29310@logos.cnet>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:28114 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261195AbVC1Rfz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2005 12:35:55 -0500
In-Reply-To: <20050328123430.GC29310@logos.cnet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-03-28 at 09:34 -0300, Marcelo Tosatti wrote:
> I'm using FC2 - FC3 probably has it updated.
> 
> Sorry for the noise.

Heh, not necessarily ... the reason for making the SCSI subsystem print
these messages is that no-one was updating any user level programs to
move to the new API ... now at least we're worrying people enough to ask
questions.

James


