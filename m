From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Announce] Emulex lpfcdriver v8.0.12 available
Date: Tue, 21 Sep 2004 13:41:49 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921134149.A22877@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C02F1C6@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:28175 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267638AbUIUMlv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 08:41:51 -0400
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F1C6@xbl3.ma.emulex.com>; from James.Smart@Emulex.Com on Mon, Sep 20, 2004 at 09:34:27PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

Except for the binary attributes the update looks nice to me.  Btw, I have
been looking over the EH code and I think the driver would benefit greatly
from an eh_target_reset method, is Emulex interested in implementing that
one?
