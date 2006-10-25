From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: Re: [patch 18/24] megaraid: Dell CERC ATA100/4ch support
Date: Wed, 25 Oct 2006 15:58:42 +0200
Message-ID: <453F6D92.8070504@tis.icnet.pl>
References: <890BF3111FB9484E9526987D912B261932E3A0@NAMAIL3.ad.lsil.com> <451AA5DF.7000403@tis.icnet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d1.icnet.pl ([212.160.220.21]:61335 "EHLO d1.icnet.pl")
	by vger.kernel.org with ESMTP id S1030438AbWJYN6V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Oct 2006 09:58:21 -0400
In-Reply-To: <451AA5DF.7000403@tis.icnet.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: akpm@osdl.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, 395174@bugs.debian.org, 374792@bugs.debian.org, 369378@bugs.debian.org

Hi Seokmann,

Janusz Krzysztofik wrote:
> Ju, Seokmann wrote:
>> Technically, I would recommend you to check F/W version and make sure 
>> it is not higher than 6.61.
>> I believe the problem happens with 6.62 or higher.
> 
> Bingo! megaraid_mbox works for me with F/W 6.61. How did you know?

Then, akpm@osdl.org wrote:
> The patch titled
> 
>      magaraid: check for firmware version
> 
> has been added to the -mm tree.  Its filename is
> 
>      megaraid-check-for-firmware-version.patch

But "stephane matis" <s.matis@gmail.com> wrote:
 > Unfortunately, FW 6.61 doesn't seem to support disks capacity over
 > 128G, a condition I noted after downgrading from 6.67.  I confirmed
 > the same behavior with two brands of 200G disks.

So the patch does not really solve the problem and probably should be
removed from the -mm tree.

However, Ju, Seokmann wrote:
> Janusz Krzysztofik wrote:
 >> Will you accept a patch that limits PCI IDs with VID=101E, DID=1960 and
>> SSVID=1028 in the new driver to exactly three models specified in its 
>> source file comments and, on the other hand, adds PCI ID of Dell CERC 
>> ATA100/4ch to the old driver?
> I've forwarded your request to program management team. But, I don't think it will be accepted.

So I ask the question again: could a patch like described above be accepted
until the problem with F/W >6.61 is solved in the new megaraid_mbox driver?

Cheers,
Janusz
