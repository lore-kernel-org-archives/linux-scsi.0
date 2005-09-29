From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Thu, 29 Sep 2005 12:22:05 -0400
Message-ID: <433C14AD.4070700@adaptec.com>
References: <Pine.LNX.4.10.10509281530190.19896-100000@master.linux-ide.org> <433C0285.3050106@adaptec.com> <433C0382.10404@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932234AbVI2QWX@vger.kernel.org>
In-Reply-To: <433C0382.10404@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Andre Hedrick <andre@linux-ide.org>, Patrick Mansfield <patmans@us.ibm.com>, Luben Tuikov <ltuikov@yahoo.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/29/05 11:08, Jeff Garzik wrote:
> Luben Tuikov wrote:
> 
>>  hardware implementation  (interconnect, SAM 4.15, 1.3)
>>      firmware implementation  (interconnect, SDS, SAM 4.6, 1.3)
>>          LLDD                     (SAM, section 5, 6, 7)
>>             Transport Layer          (SAM 4.15, SAS)
>>                  SCSI Core             (SAM section 4,5,8)
>>                     Commmand Sets        (SAM section 1)
> 
> 
> Transport class + libsas achieves this.

This is *WRONG*.  (see below)

And it doesn't "achieve" this.  Stop the FUD.
There is a _reason_ why it is the way it is.

> Maybe I will have to demonstrate using code...

Jeff,

There is a _reason_ why technical people separate concepts
in _layers_.

There is a _reason_ why technical people use Object Oriented
Paradigms describing models and design.

Do you know _what_ that reason is?

Or should I leave you to "demonstrate with code"?

Seeing that you keep _persisting_ in your ways,
I'll leave it for you to "enrich" Linux SCSI in
your "demonstrate with code".

	Luben
