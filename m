From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: aic7xxx   slowness on 2.6.13
Date: Wed, 07 Sep 2005 13:35:43 +0200
Message-ID: <431ED08F.3090808@gmx.de>
References: <8306780C060A7D4790F8BA02CBA1B6910A9499@sw-rz010.gsf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.E-Technik.uni-dortmund.de ([129.217.163.1]:64388 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S932119AbVIGLfs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Sep 2005 07:35:48 -0400
In-Reply-To: <8306780C060A7D4790F8BA02CBA1B6910A9499@sw-rz010.gsf.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bhanu, Yogesh" <yogesh@gsf.de>
Cc: linux-scsi@vger.kernel.org

Bhanu, Yogesh wrote:
> hi ,
>        I  installed 2.6.13 over the weekend  on a dual Pentium Xeon 2.4 Ghz with 6 GB RAM (My fileserver) running Debian Sarge.
> My fileserver uses external infrotrend raid . 
>  
> On switching to 2.6.13 I also switched from my older slower Symbios 53c895   to Adaptec 3960D

Please compare the "dmesg" output of 2.6.13 and the kernel you'd been using
previously.

-- 
Matthias Andree
