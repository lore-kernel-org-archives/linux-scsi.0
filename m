From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] Revert "genirq/affinity: assign vectors to all
 possible CPUs"
Date: Mon, 1 Oct 2018 14:35:08 +0200
Message-ID: <20181001123508.GA3415@lst.de>
References: <06ee23fe-ec9e-d67b-b533-d5151be74a11@molgen.mpg.de> <20180810133628.GA4131@kroah.com> <29b5f3ce-2c23-bf5e-fe50-29bedd4833e1@molgen.mpg.de> <20180810155511.GA17092@kroah.com> <f5c57bf7-b8c1-a560-d13a-d74e0f27adbb@molgen.mpg.de> <20180811135021.GA2186@kroah.com> <20180813033157.GA18254@ming.t460p> <89f2b622-3d2a-04ce-a6d1-ffb5d9612763@molgen.mpg.de> <cbd7cb64-dbfe-e085-e80b-67dad4084d69@molgen.mpg.de> <7c51fe1d-d591-90f2-8fb5-81990f8db0fe@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7c51fe1d-d591-90f2-8fb5-81990f8db0fe@molgen.mpg.de>
Sender: stable-owner@vger.kernel.org
To: Paul Menzel <pmenzel+linux-scsi@molgen.mpg.de>
Cc: Ming Lei <ming.lei@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, it+linux-scsi@molgen.mpg.de, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, linux-scsi@vger.kernel.org, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Dave Carroll <david.carroll@microsemi.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 01, 2018 at 02:33:07PM +0200, Paul Menzel wrote:
> Date: Wed, 29 Aug 2018 17:28:45 +0200
> 
> This reverts commit ef86f3a72adb8a7931f67335560740a7ad696d1d.

This seems rather odd.  If add all you'd revert the patch adding the
PCI_IRQ_AFFINITY to aacraid, not core infrastructure.
