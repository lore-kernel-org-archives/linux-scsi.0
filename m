From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 2.6] cciss: CCISS_GETLUNINFO fix
Date: Tue, 30 Nov 2004 08:39:24 +0100
Message-ID: <1101800364.2640.25.camel@laptop.fenrus.org>
References: <20041129220725.GA32035@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:26898 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S261999AbUK3Hjf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 02:39:35 -0500
In-Reply-To: <20041129220725.GA32035@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mikem@beardog.cca.cpqcorp.net, mike.miller@hp.com
Cc: linux-scsi@vger.kernel.org, andrew.patterson@hp.com

On Mon, 2004-11-29 at 16:07 -0600, mike.miller@hp.com wrote:
> This patch addresses a problem with reading the partition table struct.
> The last time this was submitted it was rejected on the grounds that the driver
> has no business reading the partition table. I don't disagree with that, but
> we have legacy apps to consider. Changing the ioctl would break those apps
> already in customers hands.

Can we at least get your / HP's commitment that future versions of said
tools will not use the ioctl ? (eg so that it eventually can be phased
out)
-- 

