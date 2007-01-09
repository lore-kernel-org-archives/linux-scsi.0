From: Stephen Hemminger <shemminger@osdl.org>
Subject: Re: [PATCH 1/5]  fixing errors handling during pci_driver resume
 stage [net]
Date: Tue, 9 Jan 2007 10:35:30 -0800
Message-ID: <20070109103530.2f10f823@freekitty>
References: <87vejgmv51.fsf@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59962 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932332AbXAISff (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Jan 2007 13:35:35 -0500
In-Reply-To: <87vejgmv51.fsf@sw.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitriy Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>, devel@openvz.org, linux-pci@atrey.karlin.mff.cuni.cz, netdev@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 09 Jan 2007 12:01:14 +0300
Dmitriy Monakhov <dmonakhov@openvz.org> wrote:

> network pci drivers have to return correct error code during resume stage in
> case of errors.
> Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
> -----

Please don't introduce one dev_err() call into a device driver if all the other
error printout's use a different interface.

-- 
Stephen Hemminger <shemminger@osdl.org>
