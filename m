From: "Dr. David Alan Gilbert" <dave@treblig.org>
Subject: Re: Question regarding SAS controllers.
Date: Sun, 23 Nov 2008 00:29:43 +0000
Message-ID: <20081123002943.GB12360@gallifrey>
References: <660360F4F2570145BD872F298951B17A5CC4073E@cosmail03.lsi.com> <alpine.DEB.1.10.0811221735240.14817@p34.internal.lan> <alpine.DEB.1.10.0811221741500.14817@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.treblig.org ([80.68.94.177]:42793 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbYKWA3v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Nov 2008 19:29:51 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811221741500.14817@p34.internal.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>

* Justin Piszcz (jpiszcz@lucidpixels.com) wrote:

<snip>

> How come the reviews are so bad for these cards?  (They mostly used the HW 
> raid function, which I am not interested in).

My experience generally is they are very stable but just not very
fast with the hardware RAID (actually I can't think of
any of the hardware raid cards that are that fast - especially for
write).

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
