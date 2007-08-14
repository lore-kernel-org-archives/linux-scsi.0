From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Linux 2.6.23-rc3
Date: Tue, 14 Aug 2007 09:04:38 -0400
Message-ID: <46C1A866.5090903@emulex.com>
References: <alpine.LFD.0.999.0708122143240.30176@woody.linux-foundation.org> <46C1717E.3030908@linpro.no> <20070814112429.GL16277@parisc-linux.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760924AbXHNNFN@vger.kernel.org>
In-Reply-To: <20070814112429.GL16277@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Tore Anderson <tore@linpro.no>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James Smart <James.Smart@Emulex.Com>
List-Id: linux-scsi@vger.kernel.org


A little more....
The -EEXIST matches http://marc.info/?l=linux-scsi&m=117699334422336&w=2
I had a bug fix at http://marc.info/?l=linux-scsi&m=117856436302690&w=2

Mathew's fix below superceeded my patch and supposedly also corrects it.

-- james s

PS: Emulex's testing has been with my fix. We haven't tested Mathew's yet.

Matthew Wilcox wrote:
> On Tue, Aug 14, 2007 at 11:10:22AM +0200, Tore Anderson wrote:
>>   I gave it a spin, and got quite a few troubles that appears related to
>>  the lpfc driver.  I don't know if these problems happened due to the
>>  recent update as the latest kernel I ran before was 2.6.20 (where I
>>  never saw problems like these).  First I see that something failed when
>>  the volumes on the SAN (on a Sun StorageTek 6140 / Engenio 3994) is
>>  registered, causing two errors errors such as:
> 
> You didn't seem to include your .config, but I assume you're using async
> scanning.  Could you try including this patch:
> 
> http://marc.info/?l=linux-scsi&m=118289275414202&w=2
> 
