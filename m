From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [2.6 patch] SCSI: possible cleanups
Date: Tue, 01 Mar 2005 17:32:06 -0500
Message-ID: <4224ED66.2020200@adaptec.com>
References: <20050228213159.GO4021@stusta.de> <4224245E.6090503@torque.net> <42247EF0.9000404@adaptec.com> <20050301221753.GA5742@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:54719 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262110AbVCAWcS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2005 17:32:18 -0500
In-Reply-To: <20050301221753.GA5742@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: dougg@torque.net, Adrian Bunk <bunk@stusta.de>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 03/01/05 17:17, Christoph Hellwig wrote:
> Doing it in the core means less duplication and avoiding updating
> all drivers.

I agree.

	Luben

