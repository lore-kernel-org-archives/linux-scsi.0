From: Ric Wheeler <ric@emc.com>
Subject: Re: end to end error recovery musings
Date: Mon, 26 Feb 2007 11:42:07 -0500
Message-ID: <45E30DDF.9090902@emc.com>
References: <45DEF6EF.3020509@emc.com>	<45DF80C9.5080606@zytor.com>	<20070224003723.GS10715@schatzie.adilger.int>	<20070224023229.GB4380@thunk.org>	<17890.28977.989203.938339@notabene.brown>	<20070226132511.GB8154@thunk.org>	<20070226151507.13a1701e@lxorguk.ukuu.org.uk>	<45E2FA3E.3040201@emc.com> <20070226170118.54371f1e@lxorguk.ukuu.org.uk>
Reply-To: ric@emc.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:16183 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030328AbXBZQpm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Feb 2007 11:45:42 -0500
In-Reply-To: <20070226170118.54371f1e@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>


Alan wrote:
>> I think that this is mostly true, but we also need to balance this against the 
>> need for higher levels to get a timely response.  In a really large IO, a naive 
>> retry of a very large write could lead to a non-responsive system for a very 
>> large time...
> 
> And losing the I/O could result in a system that is non responsive until
> the tape restore completes two days later....

Which brings us back to a recent discussion at the file system workshop on being 
more repair oriented in file system design so we can survive situations like 
this a bit more reliably ;-)

ric
