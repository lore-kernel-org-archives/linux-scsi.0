From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 1/2] cciss: cleans up warnings in the 32/64 bit
	conversions
Date: 26 Oct 2004 15:57:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098820685.2061.398.camel@mulgrave>
References: <20041021211718.GA10462@beardog.cca.cpqcorp.net>
	<1098633262.10824.35.camel@mulgrave>
	<20041026194551.GA21003@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:46813 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261434AbUJZT6V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 15:58:21 -0400
In-Reply-To: <20041026194551.GA21003@beardog.cca.cpqcorp.net>
List-Id: linux-scsi@vger.kernel.org
To: mikem <mikem@beardog.cca.cpqcorp.net>
Cc: marcelo.tosatti@cyclades.com, Jens Axboe <axboe@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-10-26 at 15:45, mikem wrote:
> Which tree are you applying to? This was made from 2.4.28-pre4.

OK, you caught me ... trying to apply a 2.4 patch to a 2.6 tree.  I keep
forgetting that not all patches on linux-scsi are 2.6

James


