From: Christoph Hellwig <hch@infradead.org>
Subject: Re: MODULE_VERSION for scsi drivers
Date: Tue, 27 Apr 2004 15:31:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040427153145.A17739@infradead.org>
References: <20040427040923.GA9901@lists.us.dell.com> <32805.4.5.45.142.1083039354.squirrel@www.osdl.org> <20040427131050.GA17777@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:54802 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264138AbUD0Obs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2004 10:31:48 -0400
Content-Disposition: inline
In-Reply-To: <20040427131050.GA17777@lists.us.dell.com>; from Matt_Domsch@dell.com on Tue, Apr 27, 2004 at 08:10:50AM -0500
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, linux-scsi@vger.kernel.org

On Tue, Apr 27, 2004 at 08:10:50AM -0500, Matt Domsch wrote:
> Per include/linux/module.h:
>   Using this automatically adds a checksum of the .c files and the
>   local headers to the end.  Use MODULE_VERSION("") if you want just
>   this.  Macro includes room for this.
> 
> So for modules which don't appear to have their own versioning, we use
> the "" mechanism to simply generate the checksum for the file.  This
> still allows tools (ala DKMS eventually) to note if something in the
> module changed even if the version string didn't.

That's totally braindead.  If you want to use a scheme like that talk
rusty into generating this without needing to add anything to the driver.

