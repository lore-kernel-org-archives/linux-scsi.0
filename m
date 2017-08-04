From: John David Anglin <dave.anglin@bell.net>
Subject: Re: Undefined behaviour in drivers/scsi/sym53c8xx_2/sym_hipd.c:762:24
Date: Fri, 4 Aug 2017 19:10:33 -0400
Message-ID: <8DE445AF-68F0-4F1C-94B3-5FE7D4C8E6C9@bell.net>
References: <d030f03a-0ccf-324b-32d6-002dfb408c16@gmx.de>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <d030f03a-0ccf-324b-32d6-002dfb408c16@gmx.de>
Sender: linux-parisc-owner@vger.kernel.org
To: Helge Deller <deller@gmx.de>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-parisc <linux-parisc@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2017-08-04, at 6:12 PM, Helge Deller wrote:

> On the parisc platform I noticed the UBSAN warning below.
> Maybe nr_divisor isn't correctly initialized ?
> Helge
> 
> [   18.555455] sym0: <896> rev 0x7 at pci 0000:00:0f.0 irq 68
> [   18.625415] ================================================================================
> [   18.726489] UBSAN: Undefined behaviour in ./drivers/scsi/sym53c8xx_2/sym_hipd.c:762:24
> [   18.864911] index -1903078336 is out of range for type 'u32 [7]'

What about np->clock_divn?

Dave
--
John David Anglin	dave.anglin@bell.net



