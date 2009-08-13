From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 4/9] mpt2sas: Config request and diag reset deadlock
Date: Thu, 13 Aug 2009 21:36:57 +0000
Message-ID: <1250199417.3901.193.camel@mulgrave.site>
References: <20090807140552.GE5807@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbZHMVhH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Aug 2009 17:37:07 -0400
In-Reply-To: <20090807140552.GE5807@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com, stable@kernel.org

On Fri, 2009-08-07 at 19:36 +0530, Kashyap, Desai wrote:
> Moving the setting and clearing of the mutex's to
> _config_request. There was a mutex deadlock when diag reset is called from
> inside _config_request, so diag reset was moved to outside the mutexs.
> ---
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> Signed-off-by: Eric Moore <Eric.moore@lsi.com>

Signoffs go before the --- othewise git ignores them, please

This patch doesn't apply.  The rest all do, so I have the other eight,
please redo this one against scsi-rc-fixes-2.6.git.

Thanks,

James


