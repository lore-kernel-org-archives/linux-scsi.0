From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 1 of 9] patches to add diskdump functionality to block
	layer
Date: Mon, 18 Apr 2005 17:43:55 +0200
Message-ID: <1113839036.6274.78.camel@laptopd505.fenrus.org>
References: <20050418153644.GA25409@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:12759 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262023AbVDRPoE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Apr 2005 11:44:04 -0400
In-Reply-To: <20050418153644.GA25409@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mike.miller@hp.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, marcelo.tosatti@cyclades.com

On Mon, 2005-04-18 at 10:36 -0500, mike.miller@hp.com wrote:
> Please review the following patches and provide any comments or feedback.
> Patch 1 of 9

what diskdump do you use?
Why do we even look at disk dump when kexec based dump can dump to disk
too and is otherwise more flexible and superior?

Maybe it's worth discussion that before doing major patches for.. well
potentially no good.


