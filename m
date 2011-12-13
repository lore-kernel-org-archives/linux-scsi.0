From: Biblioteka UR <biblio@univ.rzeszow.pl>
Subject: Re: mptspi init failure on Sparc SMP in Linux 3.0
Date: Tue, 13 Dec 2011 09:23:57 +0100
Message-ID: <4EE70B9D.5030309@univ.rzeszow.pl>
References: <4EB7D137.7090903@univ.rzeszow.pl>	 <20111107205409.GG3366@decadent.org.uk> <4EB858E8.6090304@univ.rzeszow.pl> <1320721518.18929.15.camel@deadeye> <A6888A6805518E4EA4AF7072A28264A6047262C728@inbmail02.lsi.com> <4EE5F1F4.3000006@univ.rzeszow.pl> <A6888A6805518E4EA4AF7072A28264A6047278DE4C@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atena.univ.rzeszow.pl ([62.93.43.134]:34161 "EHLO
	atena.univ.rzeszow.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab1LMIYX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2011 03:24:23 -0500
In-Reply-To: <A6888A6805518E4EA4AF7072A28264A6047278DE4C@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, "Moore, Eric" <Eric.Moore@lsi.com>, "647900@bugs.debian.org" <647900@bugs.debian.org>, linux-scsi <linux-scsi@vger.kernel.org>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

Hello Nagalakshimi.

Thank you for your reply.

W dniu 2011-12-13 08:21, Nandigama, Nagalakshmi pisze:
> The issue is happening because config page is timing out and initialization is not successful
> Can you collect the kernel messages even for the KERN_DEBUG messages also for mpt driver?
> This is to find out which config page is failing.
Maybe so, but I confess that I do not know how. :( Do you have any 
suggestions? I begin my adventure with Debian. I have little experience 
with Centos, but it doesn't work with Sparc. :)

Regards,
Mariusz
