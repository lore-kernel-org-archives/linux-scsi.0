From: Kumba <kumba@gentoo.org>
Subject: Re: qla1280: failing mbox check
Date: Tue, 16 May 2006 00:36:00 -0400
Message-ID: <446956B0.4060003@gentoo.org>
References: <446409CA.2090100@gentoo.org> <yq04pzvr9dz.fsf@jaguar.mkp.net>	<4464888A.1000807@gentoo.org> <yq0r72vps5d.fsf@jaguar.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.192.81]:49847 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S1751265AbWEPEgL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 00:36:11 -0400
In-Reply-To: <yq0r72vps5d.fsf@jaguar.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Jes Sorensen wrote:
> 
> Uh oh!, bitops changing half way? Maybe the thing to try first is to
> revert all the bitops mangling.

Yeah, thought about that, as some functions that were duplicated in the tree in 
many of the arch ports got moved from their respective asm-$arch to asm-generic, 
and appropriate tweaks added to compensate for these changes.  I remember 
something from bitops stuff changed, but I'll be blasted if I can remember what. 
  Probably gonna have to get some help from the Octane port author and some of 
the other mips hackers to try and trace down some of these changes (i.e., seems 
mips asm-offsets.c gets something weird done to it by gcc now when I run a git 
bisect and try to build it, which breaks a few of the asm files -- makes testing 
the bisect somewhat fun).


--Kumba

-- 
Gentoo/MIPS Team Lead
Gentoo Foundation Board of Trustees

"Such is oft the course of deeds that move the wheels of the world: small hands 
do them because they must, while the eyes of the great are elsewhere."  --Elrond
