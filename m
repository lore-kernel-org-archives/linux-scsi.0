From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Fwd: how to map virtual addresses for multipage SG list
Date: Mon, 16 May 2005 10:23:49 +0200
Message-ID: <1116231829.6274.22.camel@laptopd505.fenrus.org>
References: <1116223080.396680.208400@g44g2000cwa.googlegroups.com>
	 <20050516060026.3ED465FA34@attila.bofh.it>
	 <918ebc94050516010338a4d16f@mail.gmail.com>
	 <918ebc9405051601165469a611@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:48038 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261470AbVEPIXx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 04:23:53 -0400
In-Reply-To: <918ebc9405051601165469a611@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Naveen karthick <naveenkc@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2005-05-16 at 13:46 +0530, Naveen karthick wrote:
> 
> I'm writing a SCSI LLD in which i have a requirement to
> copy the SCSI mid-layer supplied request_buffer(as a SG list) in the
> Scsi_Cmnd structure to a local buffer in the LLD. Hence i need the
> virtual address of the mapped SGs but attempt to mapping results in a
> panic.

you haven't posted the url to the full sourcecode of the driver... so
how can we see what your bug is ?


