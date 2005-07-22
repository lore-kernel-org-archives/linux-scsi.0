From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 0/3] Add disk hotswap support to libata
Date: Thu, 21 Jul 2005 21:35:24 -0400
Message-ID: <42E04D5C.5010907@pobox.com>
References: <42E01024.9030600@nit.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <42E01024.9030600@nit.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Lukasz Kosewski <lkosewsk@nit.ca>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Lukasz Kosewski wrote:
> Hey all, introductory blurb here.
> 
> This sequence of patches will add a framework to libata to allow for 
> hot-swapping disks in and out.
> 
> There are three patches:
> 01-promise_sataII150_support
> 02-libata_hotswap_infrastructure
> 03-promise_hotswap_support

Pretty cool stuff!

As soon as I finish SATA ATAPI (this week[end]), I'll take a look at 
this.  A quick review of the patches didn't turn up anything terribly 
objectionable, though :)

	Jeff


P.S.  You might want to CC linux-ide as well, on libata patches.
