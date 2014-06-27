From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: help decoding aacraid errors (3.10.40 kernel)
Date: Fri, 27 Jun 2014 12:37:43 +0100
Message-ID: <20140627113743.GE10042@localhost.localdomain>
References: <201406271055.08750.a.miskiewicz@gmail.com>
 <20140627104131.GD10042@localhost.localdomain>
 <201406271259.18659.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbaF0Lhr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 07:37:47 -0400
Content-Disposition: inline
In-Reply-To: <201406271259.18659.a.miskiewicz@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Jun 27, 2014 at 12:59:18PM +0200, Arkadiusz Miskiewicz wrote:
> Thanks for links. I wonder why kernel doesn't decode these to be actually 
> readable without a need for asking on ml - was decoding considered?

Normally it does; I was a bit surprised to see numbers printed with such
a recent kernel.

Sense key decoding to text has been around almost forever (the 'snstext'
table of sense strings pre-dates git, i.e. 2.6.12ish).

Is it possible your kernel was built without CONFIG_SCSI_CONSTANTS?

Regards,
Bryn.

