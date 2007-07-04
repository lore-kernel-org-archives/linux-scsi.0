From: Dan Aloni <da-x@monatomic.org>
Subject: Re: Some NCQ numbers...
Date: Wed, 4 Jul 2007 18:44:05 +0300
Message-ID: <20070704154405.GA27166@localdomain>
References: <468392CE.6010206@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755630AbXGDPoV@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <468392CE.6010206@msgid.tls.msk.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 28, 2007 at 02:51:58PM +0400, Michael Tokarev wrote:
>[..]
> Test machine was using MPTSAS driver for the following card:
>   SCSI storage controller: LSI Logic / Symbios Logic SAS1064E PCI-Express Fusion-MPT SAS (rev 02)
> 
> Pretty similar results were obtained on an AHCI controller:
>   SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) Serial ATA Storage Controller AHCI (rev 01)
> on another machines.

Are you sure that NCQ was enabled between the controller and drive? 
Did you verify this? I know about some versions that disable NCQ 
support internally in their firmware (something to do with bugs in
error handling).

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
