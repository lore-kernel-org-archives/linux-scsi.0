From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [resend PATCH 2/5] libata: export ata_port suspend/resume infrastructure
 for sas
Date: Wed, 25 Jul 2012 01:21:47 -0400
Message-ID: <500F826B.2080405@pobox.com>
References: <20120710040434.26529.86552.stgit@dwillia2-linux.jf.intel.com> <20120710040552.26529.47482.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120710040552.26529.47482.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/10/2012 12:05 AM, Dan Williams wrote:
> Reuse ata_port_{suspend|resume}_common for sas.  This path is chosen
> over adding coordination between ata-tranport and sas-transport because
> libsas wants to revalidate the domain at resume-time at the host level.
> It can not validate links have resumed properly until libata has had a
> chance to perform its revalidation, and any sane placing of an ata_port
> in the sas-transport model would delay it's resumption until after the
> host.
>
> Export the common portion of port suspend/resume (bypass pm_runtime),
> and allow sas to perform these operations asynchronously (similar to the
> libsas async-ata probe implmentation).  Async operation is determined by
> having an external, rather than stack based, location for storing the
> result of the operation.
>
> Reviewed-by: Jacek Danecki <jacek.danecki@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Acked-by: Jeff Garzik <jgarzik@redhat.com>




