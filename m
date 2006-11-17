From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Atto UL5D: negotiates only up to FAST-40 SCSI
Date: Fri, 17 Nov 2006 15:15:52 -0600
Message-ID: <1163798152.8594.62.camel@mulgrave.il.steeleye.com>
References: <xfku00y8gjn.fsf@uxrs53.drewag.de>
	 <20061117223506.4ec56d04.vsu@altlinux.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:30678 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S933772AbWKQVQA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Nov 2006 16:16:00 -0500
In-Reply-To: <20061117223506.4ec56d04.vsu@altlinux.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergey Vlasov <vsu@altlinux.ru>
Cc: Sven Rudolph <Sven_Rudolph@drewag.de>, linux-scsi@vger.kernel.org

On Fri, 2006-11-17 at 22:35 +0300, Sergey Vlasov wrote:
> This patch still applies to 2.6.18 with some fuzz, resulting in the
> following changes:

That basically says the card doesn't use the same control flags as a
standard LSI meaning it's thoroughly confused about how the DV code is
asking it to negotiate.

James


