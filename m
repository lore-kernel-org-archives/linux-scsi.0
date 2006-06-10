From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] Build mptspi.c on architectures where CONFIG_PM is
 unset
Date: Fri, 09 Jun 2006 17:00:53 -0700 (PDT)
Message-ID: <20060609.170053.107254117.davem@davemloft.net>
References: <1149345407.14611.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <1149345407.14611.49.camel@localhost.localdomain>
Sender: sparclinux-owner@vger.kernel.org
To: tcallawa@redhat.com
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: "Tom 'spot' Callaway" <tcallawa@redhat.com>
Date: Sat, 03 Jun 2006 09:36:47 -0500

> sparc64 does not have CONFIG_PM defined, and mptscsih_resume is wrapped
> in an #ifdef CONFIG_PM in mptscsih.h. mptscsih_resume is only used in
> the mptspi_resume function in mptspi.c, and its only call is in the
> pci_driver struct (and that call is also #ifdef CONFIG_PM). In order to
> get the code to compile, I just needed to wrap the actual function in
> #ifdef CONFIG_PM, which is what this patch does. I can confirm that it
> gets the module building again without errors.
> 
> Signed-off-by: Tom "spot" Callaway <tcallawa@redhat.com>

Thanks Tom I'll apply this.
