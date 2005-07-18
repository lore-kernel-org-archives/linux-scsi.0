From: Philipp Slusallek <slusallek@cs.uni-sb.de>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Mon, 18 Jul 2005 06:50:46 +0200
Message-ID: <42DB3526.9050009@cs.uni-sb.de>
References: <20050715005309.GB14816@ime.usp.br> <20050715014312.GI13229@phunnypharm.org> <20050715155332.GA3954@ime.usp.br> <20050715172854.GJ13229@phunnypharm.org> <20050715185034.GA3903@ime.usp.br> <20050715205741.GN13229@phunnypharm.org> <20050716014225.GA9733@ime.usp.br> <20050716155637.GA22044@phunnypharm.org> <20050716164202.GA3846@ime.usp.br> <20050717165712.GA7883@phunnypharm.org> <20050717191832.GB15629@ime.usp.br> <42DAB58F.4000801@s5r6.in-berlin.de> <42DAF44D.2040500@ime.usp.br> <42DAE951.1080209@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010900060009010905030602"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from uni-sb.de ([134.96.252.33]:57823 "EHLO uni-sb.de")
	by vger.kernel.org with ESMTP id S261514AbVGREvR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jul 2005 00:51:17 -0400
In-Reply-To: <42DAE951.1080209@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>, Ben Collins <bcollins@debian.org>

This is a multi-part message in MIME format.
--------------010900060009010905030602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi all,

Stefan Richter wrote:
> Rogério Brito wrote:
>>Stefan Richter wrote:
>>>But didn't you add type 14 (RBC disk) and its association with sd_mod
>>>to your distro's scsi.agent script already...?
>>
>>Yes, I did. I'm using a patched scsi.agent as per your recommendation.
> 
> [...]
> 
>>I am now slightly puzzled.
> Me too.

I though everyone would notice it: There is an "S" missing in the 
rbc-disk line from Rogerio's scsi.agent file.

> The changes you suggested are trivial indeed and hwere is what my
> scsi.agent file has:
>  
>  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
>  dumont:~# grep sd_mod /etc/hotplug/scsi.agent
>      0)		TYPE=disk ;	MODULES=sd_mod ;;
>      7)		TYPE=mod ;	MODULES=sd_mod ;;
>      14)		TYPE=rbc-disk ;  MODULE=sd_mod ;;


	Philipp

--------------010900060009010905030602
Content-Type: text/x-vcard; charset=utf-8;
 name="slusallek.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="slusallek.vcf"

begin:vcard
fn:Philipp Slusallek
n:Slusallek;Philipp
org:Saarland University;Computer Graphics Group
adr;quoted-printable:;;Im Stadtwald, Geb. 36.1;Saarbr=C3=BCcken;;66123;Germany
email;internet:slusallek@cs.uni-sb.de
title:Prof. Dr.-Ing.
tel;work:+49 681 302 3831
tel;fax:+49 681 302 3843
tel;home:+49 6897 568904
tel;cell:+49 173 659 2518
x-mozilla-html:FALSE
url:http://graphics.cs.uni-sb.de
version:2.1
end:vcard


--------------010900060009010905030602--
