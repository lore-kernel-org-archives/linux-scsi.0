From: Arjan van de Ven <arjan@fenrus.demon.nl>
Subject: Re: [Announce] Emulex lpfcdriver v8.0.13 available
Date: Fri, 22 Oct 2004 10:56:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098435402.2789.6.camel@laptop.fenrus.com>
References: <0B1E13B586976742A7599D71A6AC733C02F224@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from i31207.upc-i.chello.nl ([62.195.31.207]:45187 "EHLO
	laptop.fenrus.com") by vger.kernel.org with ESMTP id S270891AbUJVI5B
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 04:57:01 -0400
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F224@xbl3.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Wed, 2004-10-20 at 16:20, James.Smart@Emulex.Com wrote:
> Christoph,
> - Of the six binary attributes that previously existed:

I assume you didn't add new ones either ?
> - Added ifdef's so the driver compiles/runs on:

sounds not the right approach; please submit a driver that has no
version ifdefs; it's a *new* driver, compatibility ifdefs make no sense
at all.


