From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Thu, 29 Sep 2005 11:08:50 -0400
Message-ID: <433C0382.10404@pobox.com>
References: <Pine.LNX.4.10.10509281530190.19896-100000@master.linux-ide.org> <433C0285.3050106@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932182AbVI2PI7@vger.kernel.org>
In-Reply-To: <433C0285.3050106@adaptec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Andre Hedrick <andre@linux-ide.org>, Patrick Mansfield <patmans@us.ibm.com>, Luben Tuikov <ltuikov@yahoo.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Luben Tuikov wrote:
>   hardware implementation  (interconnect, SAM 4.15, 1.3)
>       firmware implementation  (interconnect, SDS, SAM 4.6, 1.3)
>           LLDD                     (SAM, section 5, 6, 7)
>              Transport Layer          (SAM 4.15, SAS)
>                   SCSI Core             (SAM section 4,5,8)
>                      Commmand Sets        (SAM section 1)

Transport class + libsas achieves this.

Maybe I will have to demonstrate using code...

	Jeff
