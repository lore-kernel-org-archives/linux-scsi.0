From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/1] scsi_dh_emc: fix mode select request setup
Date: Wed, 02 Dec 2009 15:36:22 -0500
Message-ID: <1259786182.5430.138.camel@mulgrave.site>
References: <1259785728-20419-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51029 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025AbZLBUhK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2009 15:37:10 -0500
In-Reply-To: <1259785728-20419-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

On Wed, 2009-12-02 at 14:28 -0600, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> This patch fixes the request setup code for mode selects. I got the fixes from
> Hannes Reinecke while trying to hunt down some problems and merged it
> into one patch. I am sending it because Hannes is busy with other things.

So that should be From: Hannes Reineke at the top then?  (I can fix it
up if it is)

James


