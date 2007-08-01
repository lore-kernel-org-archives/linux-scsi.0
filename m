From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 1/4] Store interrupt value
Date: Wed, 01 Aug 2007 10:01:31 -0400
Message-ID: <46B0923B.4040707@garzik.org>
References: <20070705194909.337398431@intel.com> <20070705130500.ad5f7739.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:54008 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095AbXHAOBg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Aug 2007 10:01:36 -0400
In-Reply-To: <20070705130500.ad5f7739.kristen.c.accardi@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@steeleye.com, edwintorok@gmail.com, axboe@kernel.dk, linux-scsi@vger.kernel.org

Kristen Carlson Accardi wrote:
> Use a stored value for which interrupts to enable.  Changing this allows
> us to selectively turn off certain interrupts later and have them 
> stay off.
> 
> Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

ACK.  Regenerate against current kernel and I'll apply immediately 
(tried to do so just now)


