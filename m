From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Target mode drivers
Date: Sun, 22 Jan 2006 18:35:39 +0300
Message-ID: <43D3A64B.9040300@vlnb.net>
References: <43CE2344.2090503@gmail.com> <20060119005753.GB17765@hugang.soulinfo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out-relay-01.infobox.ru ([195.208.234.170]:35999 "EHLO
	out-relay-01.infobox.ru") by vger.kernel.org with ESMTP
	id S1751274AbWAVPgt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jan 2006 10:36:49 -0500
In-Reply-To: <20060119005753.GB17765@hugang.soulinfo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hugang@soulinfo.com
Cc: Nagaprabhanjan Bellari <nagp.lists@gmail.com>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

hugang@soulinfo.com wrote:
> On Wed, Jan 18, 2006 at 04:45:16PM +0530, Nagaprabhanjan Bellari wrote:
> 
>>Hi,
>>
>>Does anybody know of any SCSI target mode drivers (for HBAs) available 
>>open source?
>>
>>Please let me know.
> 
> 
> SCSI target mode for linux
> http://scst.sf.net/
> 
> I has been works on some scsi hba to enable target mode in linux, here
> is some source code for it. currently we support 
> 
> QLOGIC ISP base
>   1040
>   23xx
>  
> Adaptec 
>   160 base card seem work well.
>   320 base card can't works right now.
> 
> LSI 
>   all MPT base including the FC and SAS, but the SCSI interface has not test
>   passed.
> 
> http://bj.soulinfo.com/~hugang/scst/tgt/

Wow, 3 new target drivers at once!

Could you pack the source code in one .tgz per driver and put the 
archives somewhere on your server, please? Then I will put a reference 
to them on the SCST's page on sf.net and in SCST's README file (if you 
don't object, of course).

Vlad

