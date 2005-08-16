From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2.6.13-rc6] improve start/stop code for worker thread in cpqfcTS driver, take 2
Date: Tue, 16 Aug 2005 17:24:57 +0100
Message-ID: <20050816162457.GA29799@infradead.org>
References: <200508051202.07091@bilbo.math.uni-mannheim.de> <200508161114.39675@bilbo.math.uni-mannheim.de> <200508161658.15546@bilbo.math.uni-mannheim.de> <200508161820.57817@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:21466 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030220AbVHPQY6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Aug 2005 12:24:58 -0400
Content-Disposition: inline
In-Reply-To: <200508161820.57817@bilbo.math.uni-mannheim.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Bolke de Bruin <bdbruin@aub.nl>

On Tue, Aug 16, 2005 at 06:20:56PM +0200, Rolf Eike Beer wrote:
> Use pid of worker thread and struct completion for signaling end of worker 
> thread (code more or less taken from drivers/net/8139too.c). For the moment 
> the return code of the start/stop functions is ignored, this will change 
> once the init/exit code is changed to use 2.6 driver model.

thread start/stop should use the kthread.h API.  Not that this helps at
all for this driver..

