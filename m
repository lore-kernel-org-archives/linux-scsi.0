From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Some NCQ numbers...
Date: Wed, 04 Jul 2007 20:17:35 +0400
Message-ID: <468BC81F.7090102@msgid.tls.msk.ru>
References: <468392CE.6010206@msgid.tls.msk.ru> <20070704154405.GA27166@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070704154405.GA27166@localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Aloni <da-x@monatomic.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Dan Aloni wrote:
> On Thu, Jun 28, 2007 at 02:51:58PM +0400, Michael Tokarev wrote:
>> [..]
>> Test machine was using MPTSAS driver for the following card:
>>   SCSI storage controller: LSI Logic / Symbios Logic SAS1064E PCI-Express Fusion-MPT SAS (rev 02)
>>
>> Pretty similar results were obtained on an AHCI controller:
>>   SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) Serial ATA Storage Controller AHCI (rev 01)
>> on another machines.
> 
> Are you sure that NCQ was enabled between the controller and drive? 
> Did you verify this? I know about some versions that disable NCQ 
> support internally in their firmware (something to do with bugs in
> error handling).

The next obvious question is: how to check/verify this?

/mjt
