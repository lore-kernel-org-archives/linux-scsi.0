From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] scsi_transport_sas: introduce a sas_port entity
Date: Wed, 31 May 2006 12:22:19 -0500
Message-ID: <1149096139.22134.56.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D70141DC9@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:164 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751734AbWEaRWW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 May 2006 13:22:22 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70141DC9@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2006-05-31 at 11:10 -0600, Moore, Eric wrote:
> Just want to confirm whether these two API is for handling
> adding/deleting phys to the sas_port object once the wide port is
> formed?

Yes, that's the idea (and the use case in aic94xx).

There's probably going to be another API iteration, but more around
allowing the adding of phys before the port is made visible.

James


