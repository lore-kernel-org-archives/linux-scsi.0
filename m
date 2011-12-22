From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [RFC-v4 0/3] qla2xxx: v3.4 target mode LLD changes + tcm_qla2xxx
 fabric module
Date: Thu, 22 Dec 2011 14:25:20 -0800
Message-ID: <20111222222520.GP22063@plapa.qlogic.org>
References: <1324173746-14361-1-git-send-email-nab@linux-iscsi.org>
 <20111221171135.GA27369@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:35662
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752932Ab1LVWZx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Dec 2011 17:25:53 -0500
Content-Disposition: inline
In-Reply-To: <20111221171135.GA27369@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, James Bottomley <JBottomley@Parallels.com>, Roland Dreier <roland@purestorage.com>, Joern Engel <joern@logfs.org>, Madhuranath Iyengar <mni@risingtidesystems.com>

On Wed, 21 Dec 2011, Christoph Hellwig wrote:

> I think the most important item is to sort out the mess around the old
> generation qla23xx support.  The way the code currently sprinkles ifs
> around that is a complete mess.  Given that the qla23xx support has as
> far as I know zero test coverage, and has been EOLed by qlogic I see
> no reason to keep it around.
> 
> Anyone disagreeing with that?
> 

Christoph,

>From an engineering and support perspective it doesn't make sense to
keep the (unsupported and untested) pre-ISP24xx codes around.  Going
forward, once internal resources can be allocated, QLogic would like
to see support for all ISP24xx and above hardware.

Regards,
Andrew Vasquez

