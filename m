From: hugang@soulinfo.com
Subject: Re: Target mode drivers
Date: Mon, 23 Jan 2006 12:48:25 +0800
Message-ID: <20060123044825.GA4763@hugang.soulinfo.com>
References: <43CE2344.2090503@gmail.com> <20060119005753.GB17765@hugang.soulinfo.com> <43D3A64B.9040300@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [220.248.27.114] ([220.248.27.114]:5260 "HELO soulinfo.com")
	by vger.kernel.org with SMTP id S964797AbWAWFgR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jan 2006 00:36:17 -0500
Content-Disposition: inline
In-Reply-To: <43D3A64B.9040300@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: hugang@soulinfo.com, Nagaprabhanjan Bellari <nagp.lists@gmail.com>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

On Sun, Jan 22, 2006 at 06:35:39PM +0300, Vladislav Bolkhovitin wrote:
> hugang@soulinfo.com wrote:
> >On Wed, Jan 18, 2006 at 04:45:16PM +0530, Nagaprabhanjan Bellari wrote:
> >
> >>Hi,
> >>
> >>Does anybody know of any SCSI target mode drivers (for HBAs) available 
> >>open source?
> >>
> >>Please let me know.
> >
> >
> >SCSI target mode for linux
> >http://scst.sf.net/
> >
> >I has been works on some scsi hba to enable target mode in linux, here
> >is some source code for it. currently we support 
> >
> >QLOGIC ISP base
> >  1040
> >  23xx
> > 
> >Adaptec 
> >  160 base card seem work well.
> >  320 base card can't works right now.
> >
> >LSI 
> >  all MPT base including the FC and SAS, but the SCSI interface has not 
> >  test
> >  passed.
> >
> >http://bj.soulinfo.com/~hugang/scst/tgt/
> 
> Wow, 3 new target drivers at once!
> 
> Could you pack the source code in one .tgz per driver and put the 
> archives somewhere on your server, please? Then I will put a reference 
> to them on the SCST's page on sf.net and in SCST's README file (if you 
> don't object, of course).

http://bj.soulinfo.com/~hugang/scst/tgt/

Here is it.

> 
> Vlad
> 
> 

-- 
   .-.      .-.    _              
   : :      : :   :_;             
 .-' : .--. : `-. .-. .--.  ,-.,-.
' .; :' '_.'' .; :: :' .; ; : ,. :
`.__.'`.__.'`.__.':_;`.__,_;:_;:_;

Hu Gang
