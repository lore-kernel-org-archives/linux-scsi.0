From: Andrew Morton <akpm@digeo.com>
Subject: Re: [PATCH] reduce stack in qlogicfc.c
Date: Wed, 12 Mar 2003 00:52:20 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030312005220.637494ae.akpm@digeo.com>
References: <3E6ECFAD.A4363F5E@verizon.net>
	<20030312072049.GA2428@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id AAA01819
	for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2003 00:51:21 -0800 (PST)
In-Reply-To: <20030312072049.GA2428@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: randy.dunlap@verizon.net, linux-scsi@vger.kernel.org

Mike Anderson <andmike@us.ibm.com> wrote:
>
> Randy.Dunlap [randy.dunlap@verizon.net] wrote:
> > Can anyone suggest way(s) to have the isp2x00_make_portdb() function
> > called over and over again until it gets its job done?
> > Or does anyone even still use this driver?
> 
> We have been using the Feral as it covers both Qlogic SCSI and FC cards
> (both 2200 and 2300 series, the qlogicfc only handles 2200). I believe
> Andrew Morton is carrying the driver in the mm series of patches.
> 

Does it work?   After an initial spurt of not-so-hot testing reports
everything went quiet and I'd assumed people had given up on it
for the while.

