From: Kyle McMartin <kyle@parisc-linux.org>
Subject: Re: [PATCH] Fix scsi/scsi_transport.h compile error
Date: Mon, 31 Jul 2006 09:14:46 -0400
Message-ID: <20060731131446.GB6087@athena.road.mcmartin.ca>
References: <200607310943.25384.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:21921 "EHLO
	stout.engsoc.carleton.ca") by vger.kernel.org with ESMTP
	id S1751021AbWGaNPT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jul 2006 09:15:19 -0400
Content-Disposition: inline
In-Reply-To: <200607310943.25384.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Mon, Jul 31, 2006 at 09:43:25AM +0200, Rolf Eike Beer wrote:
> scsi_transport.h defines the inline function scsi_transport_device_data()
> that dereferences a pointer of "struct scsi_device *". Since the struct is
> not known by the header this might break compilation.

This should be solved with a "struct scsi_device;" decl, instead of
Yet More Header Dependancies...

--Kyle
