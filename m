From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [gregoire.favre@gmail.com: What breaks aic7xxx in post
	2.6.12-rc2 ?]
Date: Mon, 16 May 2005 10:46:41 -0500
Message-ID: <1116258401.5040.14.camel@mulgrave>
References: <20050516152607.GA27989@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:38317 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261697AbVEPPqs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 11:46:48 -0400
In-Reply-To: <20050516152607.GA27989@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gr?goire Favre <gregoire.favre@gmail.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-05-16 at 16:26 +0100, Christoph Hellwig wrote:
> Anyone got an idea on what's going wrong ?

As I read it, nothing is going wrong ... the trace indicates that the
device is eventually configured async by DV, so the system comes up with
it's full complement of devices.  Which device is this by the way, the
inquiry information is missing from the top.

The bug is that the DV code should shut the driver up while it probes to
avoid frightening users (particularly as the aic7xxx driver prints lots
of scary messages while its in error handling).

James


